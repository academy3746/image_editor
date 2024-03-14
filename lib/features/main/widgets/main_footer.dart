import 'package:flutter/material.dart';
import 'package:image_editor/common/constants/sizes.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({
    super.key,
    required this.onEmotionTap,
  });

  final void Function(int id) onEmotionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      height: Sizes.size150,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            7,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size10),
                child: GestureDetector(
                  onTap: () {
                    onEmotionTap(index + 1);
                  },
                  child: Image.asset(
                    height: Sizes.size100,
                    'assets/images/emoticon_${index + 1}.png',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
