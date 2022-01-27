import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner_app_flutter/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:ui' as ui;

class QRCodeGeneratorScreen extends StatefulWidget {
  const QRCodeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeGeneratorScreen> createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  final _globalKey = GlobalKey();
  final _textController = TextEditingController();
  String _qrData = '';
  bool _isShowQR = false;
  bool _isSubmitted = false;

  String? get _errorMessage {
    String text = _textController.text.trim();
    if (text.isEmpty) {
      return 'Content is empty';
    } else {
      return null;
    }
  }

  Future _capturePng() async {
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    RenderRepaintBoundary? boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage(pixelRatio: devicePixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Request permissions if not already granted
    if (!(await Permission.storage.status.isGranted)) {
      await Permission.storage.request();
    }

    await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      name: 'QR code',
      quality: 100,
    );

    Flushbar(
      message: 'Download successfully',
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(milliseconds: 1500),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      borderRadius: BorderRadius.circular(10),
      icon: const Icon(
        Icons.download_done,
        color: Colors.green,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: showQRcode(),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter your content',
                  style: titleStyle,
                ),
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  errorText: _isSubmitted ? _errorMessage : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                minLines: 1,
                maxLines: 2,
              ),
              const SizedBox(
                height: 15,
              ),
              buildButton(
                iconData: Icons.sync,
                text: 'Generate QR',
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    _isSubmitted = true;
                    _qrData = _textController.text.trim();
                    if (_qrData.isEmpty) {
                      _isShowQR = false;
                    } else {
                      _isShowQR = true;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 6,
              ),
              buildButton(
                  iconData: Icons.download,
                  text: 'Download QR',
                  onPressed: _isShowQR ? _capturePng : null),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required IconData iconData,
    required String text,
    required onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: blackColor,
      ),
      label: Text(
        text,
        style: titleStyle,
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  Widget showQRcode() {
    return Container(
      width: 220,
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffB0D617),
            Color(0xffFDB100),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: whiteColor,
          // gradient:
        ),
        alignment: Alignment.center,
        child: AnimatedCrossFade(
          firstChild: const Text('Create your QR code'),
          secondChild: QrImage(
            data: _qrData,
            version: QrVersions.auto,
            errorStateBuilder: (ctx, error) => const Text(
              "Uh oh! Something went wrong...",
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _isShowQR ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
