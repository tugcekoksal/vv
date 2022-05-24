// Vendor
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/screens/views/bike_detail_scan.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  bool canScan = true;
  bool isSnackBarActive = false;
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

  final snackBar = const SnackBar(
      content: Text('Vous n\'avez pas accès aux données de ce vélo.'),
      backgroundColor: Colors.red);

  showBikeDetailScanPage(id) async {
    await bikeController.fetchUserBike(id);

    if (bikeController.error.value == "") {
      bikeController.isViewingScanPage(true);
      Get.to(() => const BikeDetailScan(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400));
    } else {
      // ScaffoldMessenger.of(context).clearSnackBars();
      if (!isSnackBarActive) {
        isSnackBarActive = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar)
            .closed
            .then((value) => {isSnackBarActive = false});
      }
    }
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
        if (result != null &&
            !bikeController.isViewingScanPage.value &&
            canScan) {
          canScan = false;
          Future.delayed(const Duration(seconds: 1), () {
            canScan = true;
          });
          showBikeDetailScanPage(int.parse(result!.code!));
        }
      });
    });
  }
}
