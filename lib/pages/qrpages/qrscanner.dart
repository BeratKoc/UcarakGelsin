import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
 String? _url="https://www.youtube.com/watch?v=T0qbFgbFhg0";
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(
            bottom: 10,
            child: buildResult(),
          )
        ],
      ),
    );
  }

  Widget buildQrView(context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      
      setState(() {
        result = scanData;
        _url=result!.code;
        
      });
      
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Widget buildResult() {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white24,
        
      ),
        child: Column(
          children: [
            Text(
      result != null ? "Result: ${result!.code}" : 'Scan a code',
      style: TextStyle(),
    ),
    ElevatedButton(onPressed: _launchURL, child: Text('Open In App')),
          ],
        ));
  }
  void _launchURL() async {
  if (!await launch(
    _url!,
    forceWebView: false,
    enableJavaScript: true,
  )) throw 'Could not launch $_url';
}
}
