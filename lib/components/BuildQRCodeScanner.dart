// Vendor
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/screens/views/bike_detail_scan.dart';

class BuildQRCodeScanner extends StatefulWidget {
  const BuildQRCodeScanner({Key? key}) : super(key: key);

  @override
  State<BuildQRCodeScanner> createState() => _BuildQRCodeScannerState();
}

class _BuildQRCodeScannerState extends State<BuildQRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  final BikeController bikeController = Get.put(BikeController());

  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  showBikeDetailScanPage(id) async {
    bikeController.isViewingScanPage(true);
    await bikeController.fetchUserBike(id);
    Get.to(() => BikeDetailScan());
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderLength: 60,
            borderWidth: 5.0,
            borderRadius: 20.0,
            borderColor: Colors.white));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        result = barcode;

        if (result != null && !bikeController.isViewingScanPage.value) {
          showBikeDetailScanPage(int.parse(result!.code!));
        }
      });
    });
  }
}
