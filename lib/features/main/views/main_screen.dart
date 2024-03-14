// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:image_editor/common/utils/back_handler_button.dart';
import 'package:image_editor/features/main/widgets/main_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// 뒤로가기 처리
  BackHandlerButton? backHandlerButton;

  /// 갤러리에서 이미지 선택
  void _onPickImage() {}

  /// 이미지 저장
  void _onSaveImage() {}

  /// 스티커 삭제
  void _onDeleteImage() {}

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
          ],
        ),
      ),
    );
  }
}
