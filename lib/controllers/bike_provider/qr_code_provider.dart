// Vendor

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Controllers

// Models

//DATE FORMAT
// Services

final qrCodeProvider = ChangeNotifierProvider.autoDispose<QrCodeProvider>(
    (ref) => QrCodeProvider());

class QrCodeProvider extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  bool canScan = true;
  bool isSnackBarActive = false;
  double loading = 0;

  // Initialisation
  QrCodeProvider();

  void setCanScan(bool xCanScan) {
    canScan = xCanScan;
    notifyListeners();
  }
}
