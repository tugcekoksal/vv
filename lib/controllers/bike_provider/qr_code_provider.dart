// Vendor
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Controllers
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/helpers/usefull.dart';
import 'package:velyvelo/models/bike/user_bike_model.dart';
import 'package:velyvelo/helpers/logger.dart';

// Models
import 'package:velyvelo/models/map/map_model.dart';

//DATE FORMAT
import 'package:intl/intl.dart';
// Services
import 'package:velyvelo/services/http_service.dart';

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
