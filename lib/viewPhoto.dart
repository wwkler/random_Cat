import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatelessWidget {
  final String catUrl;

  const ViewPhoto({required this.catUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(catUrl),
      
    );
  }
}
