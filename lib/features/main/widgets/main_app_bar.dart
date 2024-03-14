import 'package:flutter/material.dart';
import 'package:image_editor/common/constants/sizes.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key,
    required this.onPickImage,
    required this.onSaveImage,
    required this.onDeleteImage,
  });

  final void Function() onPickImage;

  final void Function() onSaveImage;

  final void Function() onDeleteImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.size100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          /// 갤러리에서 이미지 선택
          IconButton(
            onPressed: onPickImage,
            icon: Icon(
              Icons.image_search_rounded,
              color: Colors.grey.shade700,
            ),
          ),

          /// 스티커 삭제
          IconButton(
            onPressed: onDeleteImage,
            icon: Icon(
              Icons.delete_forever_rounded,
              color: Colors.grey.shade700,
            ),
          ),

          /// 이미지 저장
          IconButton(
            onPressed: onSaveImage,
            icon: Icon(
              Icons.save_alt_outlined,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
