import 'package:flutter/material.dart';
import '../models/gallery_item.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

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
          // Caption 제거, 사진만 깔끔하게 보여줌
          // 향후 상세보기 등에서 caption을 보여주고 싶으면 별도 구현
        ],
      ),
    );
  }
}


