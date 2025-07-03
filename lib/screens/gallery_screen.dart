import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/gallery_item.dart';
import '../models/gallery_folder.dart';
import '../theme/app_theme.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

// GalleryFolderTile 위젯 통합
class GalleryFolderTile extends StatelessWidget {
  final GalleryFolder folder;
  final VoidCallback onTap;
  const GalleryFolderTile({super.key, required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 110,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder, size: 36, color: Colors.amber[700]),
                  SizedBox(height: 8),
                  Text(
                    folder.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2),
                  Text('${folder.items.length}장', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GalleryTile extends StatelessWidget {
  final GalleryItem item;
  const GalleryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: item.imageUrl.startsWith('http')
                ? Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  )
                : (item.imageUrl.contains('assets/gallery/')
                    ? Image.asset(
                        item.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : (kIsWeb
                        ? Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(item.imageUrl),
                            fit: BoxFit.cover,
                          ))),
          ),
        ],
      ),
    );
  }
}

// ----------------------
// 상태 클래스 시작
class _GalleryScreenState extends State<GalleryScreen> {
  List<GalleryFolder> folders = [];
  int selectedFolderIdx = 0;
  final img_picker.ImagePicker _picker = img_picker.ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('gallery_folders');
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      setState(() {
        folders = decoded.map((e) => GalleryFolder.fromJson(e)).toList();
      });
    } else {
      setState(() {
        folders = [
          GalleryFolder(name: '기본', items: [
            GalleryItem(
              imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
              caption: '인생네컷 #1',
              date: DateTime(2024, 6, 1),
            ),
            GalleryItem(
              imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
              caption: '데이트 추억',
              date: DateTime(2024, 6, 15),
            ),
            GalleryItem(
              imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
              caption: '여행 사진',
              date: DateTime(2024, 6, 20),
            ),
          ])
        ];
      });
      await _saveGallery();
    }
  }

  Future<void> _saveGallery() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gallery_folders', jsonEncode(folders.map((e) => e.toJson()).toList()));
  }

  void resetGallery() async {
    setState(() {
      folders = [
        GalleryFolder(name: '기본', items: [
          GalleryItem(
            imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
            caption: '인생네컷 #1',
            date: DateTime(2024, 6, 1),
          ),
          GalleryItem(
            imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
            caption: '데이트 추억',
            date: DateTime(2024, 6, 15),
          ),
          GalleryItem(
            imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
            caption: '여행 사진',
            date: DateTime(2024, 6, 20),
          ),
        ])
      ];
      selectedFolderIdx = 0;
    });
    await _saveGallery();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFolder = folders.isNotEmpty ? folders[selectedFolderIdx] : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(
            color: AppTheme.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.paleBlue,
        iconTheme: IconThemeData(color: AppTheme.blue),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: folders.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, idx) => GalleryFolderTile(
                        folder: folders[idx],
                        onTap: () {
                          setState(() {
                            selectedFolderIdx = idx;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.create_new_folder, color: AppTheme.blue),
                  tooltip: '폴더 만들기',
                  onPressed: _showCreateFolderDialog,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selectedFolder == null
                ? const Center(child: Text('폴더가 없습니다.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1,
                    ),
                    itemCount: selectedFolder.items.length,
                    itemBuilder: (context, idx) => GalleryTile(item: selectedFolder.items[idx]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickImage,
        icon: Icon(Icons.add_a_photo, color: AppTheme.blue),
        label: Text('사진 업로드', style: TextStyle(color: AppTheme.blue)),
        backgroundColor: AppTheme.mint,
        tooltip: '사진 추가',
      ),
    );
  }

  Future<void> _pickImage() async {
    if (folders.isEmpty) return;
    try {
      final img_picker.XFile? pickedFile = await _picker.pickImage(source: img_picker.ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          folders[selectedFolderIdx].items.add(GalleryItem(
            imageUrl: file.path,
            caption: '',
            date: DateTime.now(),
          ));
        });
        await _saveGallery();
      }
    } catch (e) {
      if (kDebugMode) print('Image pick error: $e');
    }
  }

  void _showCreateFolderDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 폴더 만들기'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '폴더 이름'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty && !folders.any((f) => f.name == name)) {
                setState(() {
                  folders.add(GalleryFolder(name: name, items: []));
                  selectedFolderIdx = folders.length - 1;
                });
                _saveGallery();
                Navigator.pop(context);
              }
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }
}
