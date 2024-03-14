// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/common/utils/app_snackbar.dart';
import 'package:image_editor/common/utils/back_handler_button.dart';
import 'package:image_editor/features/main/models/sticker_model.dart';
import 'package:image_editor/features/main/widgets/emoticon_sticker.dart';
import 'package:image_editor/features/main/widgets/main_app_bar.dart';
import 'package:image_editor/features/main/widgets/main_footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Image 객체 생성
  XFile? _image;

  /// 스티거 저장 용도 멤버변수
  Set<StickerModel> stickers = {};

  /// 스티커 고유 ID 부여
  String? selectedId;

  /// 이미지 고유 Key
  GlobalKey imgKey = GlobalKey();

  /// 뒤로가기 처리
  BackHandlerButton? backHandlerButton;

  /// 갤러리에서 이미지 선택
  Future<void> _onPickImage() async {
    final fileImg = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = fileImg;
    });
  }

  /// 이미지 저장
  Future<void> _onSaveImage() async {
    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 100,
    );

    if (mounted) {
      var snackbar = AppSnackbar(
        context: context,
        msg: '이미지가 갤러리에 저장 되었습니다!',
      );

      snackbar.showSnackbar(context);
    }
  }

  /// 스티커 삭제
  Future<void> _onDeleteImage() async {
    setState(() {
      stickers = stickers.where((data) => data.id != selectedId).toSet();
    });
  }

  /// Footer Tab
  Future<void> _onEmotionTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: const Uuid().v4(),
          imgPath: 'assets/images/emoticon_$index.png',
        ),
      };
    });
  }

  /// Emoticon Gesture Call Back
  void _onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  @override
  void initState() {
    super.initState();

    backHandlerButton = BackHandlerButton(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (backHandlerButton != null) {
          return backHandlerButton!.onWillPop();
        }

        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _mainScreenBody(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MainAppBar(
                onPickImage: _onPickImage,
                onSaveImage: _onSaveImage,
                onDeleteImage: _onDeleteImage,
              ),
            ),
            if (_image != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MainFooter(onEmotionTap: _onEmotionTap),
              ),
          ],
        ),
      ),
    );
  }

  Widget _mainScreenBody() {
    if (_image != null) {
      return RepaintBoundary(
        key: imgKey,
        child: Positioned.fill(
          child: InteractiveViewer(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(_image!.path),
                  fit: BoxFit.cover,
                ),
                ...stickers.map(
                  (data) {
                    return Center(
                      child: EmoticonSticker(
                        key: ObjectKey(data.id),
                        onTransform: () {
                          _onTransform(data.id);
                        },
                        imgPath: data.imgPath,
                        selected: selectedId == data.id,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          onPressed: _onPickImage,
          child: const Text(
            '이미지 선택',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
