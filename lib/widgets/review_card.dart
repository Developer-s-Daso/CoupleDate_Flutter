import 'package:flutter/material.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(review.user, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(review.content),
        trailing: Text(
          '${review.date.year}.${review.date.month.toString().padLeft(2, '0')}.${review.date.day.toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
