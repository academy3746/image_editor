import 'package:flutter/material.dart';
import 'package:image_editor/common/constants/sizes.dart';

class EmoticonSticker extends StatefulWidget {
  const EmoticonSticker({
    super.key,
    required this.onTransform,
    required this.imgPath,
    required this.selected,
  });

  final void Function() onTransform;

  final String imgPath;

  final bool selected;

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  /// 확대 및 축소 배율
  double scale = 1;

  /// 가로축 움직임
  double horizontal = 0;

  /// 세로축 움직임
  double vertical = 0;

  /// 위젯의 초기 크기 기준 확대 및 축소 배율
  double autoScale = 1;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          horizontal,
          vertical,
        )
        ..scale(
          scale,
          scale,
        ),
      child: Container(
        decoration: widget.selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.size6),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1,
                ),
              )
            : BoxDecoration(
                border: Border.all(
                  color: Colors.transparent,
                  width: 1,
                ),
              ),
        child: GestureDetector(
          onTap: () {
            widget.onTransform();
          },
          onScaleUpdate: (details) {
            widget.onTransform();

            setState(() {
              scale = details.scale * autoScale;

              vertical += details.focalPointDelta.dy;

              horizontal += details.focalPointDelta.dx;
            });
          },
          onScaleEnd: (details) {
            setState(() {
              autoScale = scale;
            });
          },
          child: Image.asset(widget.imgPath),
        ),
      ),
    );
  }
}
