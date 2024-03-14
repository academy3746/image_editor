// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor/common/utils/back_handler_button.dart';
import 'package:image_editor/features/main/models/sticker_model.dart';
import 'package:image_editor/features/main/widgets/emoticon_sticker.dart';
import 'package:image_editor/features/main/widgets/main_app_bar.dart';
import 'package:image_editor/features/main/widgets/main_footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
  Future<void> _onSaveImage() async {}

  /// 스티커 삭제
  Future<void> _onDeleteImage() async {}

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
      return Positioned.fill(
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
