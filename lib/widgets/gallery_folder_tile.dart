import 'package:flutter/material.dart';
import '../models/gallery_folder.dart';

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
                  Text('${folder.items.length}\uc7a5', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
