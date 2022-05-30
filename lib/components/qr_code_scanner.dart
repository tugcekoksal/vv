// Vendor
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';
import 'package:velyvelo/controllers/bike_provider/qr_code_provider.dart';
import 'package:velyvelo/controllers/map_provider/camera_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/views/bike_detail_scan.dart';

showBikeDetailScanPage(int id, QrCodeProvider qrCode,
    BikeProfileProvider bikeProfile, BuildContext context) async {
  print(id);
  // Future(() => {bikeProfile.setVeloPk(id)});

  bikeProfile.fetchUserBike(id).then((value) {
    if (bikeProfile.messageError == "") {
      bikeProfile.isViewingScanPage = true;
      Get.off(() => const BikeDetailScan(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 400));
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      const snackBar = SnackBar(
          content: Text('Vous n\'avez pas accès aux données de ce vélo.'),
          backgroundColor: Colors.red);
      if (!qrCode.isSnackBarActive) {
        qrCode.isSnackBarActive = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar)
            .closed
            .then((value) => {qrCode.isSnackBarActive = false});
      }
    }
  });
  print("show bike detail scan page");
}

void barCodeFound(Barcode? code, QrCodeProvider qrCode,
    BikeProfileProvider bikeProfile, BuildContext context) async {
  qrCode.result = code;
  if (qrCode.result != null &&
      !bikeProfile.isViewingScanPage &&
      qrCode.canScan) {
    print("IF IT");
    qrCode.canScan = false;
    showBikeDetailScanPage(int.tryParse(qrCode.result!.rawValue!) ?? 0, qrCode,
            bikeProfile, context)
        .then(() => {qrCode.canScan = true});
  }
}

class QRCodeScanner extends ConsumerWidget {
  QRCodeScanner({Key? key}) : super(key: key);

  final snackBar = const SnackBar(
      content: Text('Vous n\'avez pas accès aux données de ce vélo.'),
      backgroundColor: Colors.red);
  final log = logger(QRCodeScanner);
  final MobileScannerController controller =
      MobileScannerController(torchEnabled: false);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return Text("wgwg");
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.white,
        ),
        Center(
          child: Container(
            clipBehavior: Clip.antiAlias,
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: MobileScanner(
              fit: BoxFit.cover,
              controller: controller,
              allowDuplicates: true,
              onDetect: (barcode, args) {
                log.e(barcode.rawValue);
                if (barcode.rawValue != null) {
                  log.d('Barcode found!');
                  barCodeFound(barcode, ref.read(qrCodeProvider),
                      ref.watch(bikeProfileProvider), context);
                } else {
                  log.e('Failed to scan Barcode');
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
