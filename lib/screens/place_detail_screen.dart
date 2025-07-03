import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/review.dart';
import '../services/favorites_service.dart';
import '../widgets/review_card.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  bool _isFavorite = false;
  final FavoritesService _favoritesService = FavoritesService();
  final List<Review> _reviews = [
    Review(
      id: '1',
      placeId: 'dummy',
      user: '커플A',
      content: '분위기가 너무 좋아요! 추천합니다.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Review(
      id: '2',
      placeId: 'dummy',
      user: '커플B',
      content: '기억에 남는 데이트 장소였어요 :)',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final fav = await _favoritesService.isFavorite(widget.place.id);
    setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _favoritesService.removeFavorite(widget.place.id);
    } else {
      await _favoritesService.addFavorite(widget.place.id);
    }
    setState(() => _isFavorite = !_isFavorite);
  }

  void _addReview() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _reviews.insert(
        0,
        Review(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          placeId: widget.place.id,
          user: '나',
          content: _controller.text.trim(),
          date: DateTime.now(),
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Color(0xFF4FC3F7)),
            onPressed: _toggleFavorite,
            tooltip: _isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.place.address, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (widget.place.phone != null && widget.place.phone!.isNotEmpty)
              Text('전화번호: ${widget.place.phone!}'),
            if (widget.place.category != null && widget.place.category!.isNotEmpty)
              Text('카테고리: ${widget.place.category!}'),
            const SizedBox(height: 16),
            const Text('리뷰 및 추억', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: _reviews.isEmpty
                  ? const Text('아직 리뷰가 없습니다. 첫 리뷰를 남겨보세요!')
                  : ListView.builder(
                      itemCount: _reviews.length,
                      itemBuilder: (context, idx) => ReviewCard(review: _reviews[idx]),
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '리뷰 또는 추억을 남겨보세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF4FC3F7)),
                  onPressed: _addReview,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
