// Vendor
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';
import 'package:velyvelo/controllers/bike_provider/qr_code_provider.dart';
import 'package:velyvelo/helpers/logger.dart';
import 'package:velyvelo/screens/views/bike_detail_scan.dart';

showBikeDetailScanPage(int id, QrCodeProvider qrCode,
    BikeProfileProvider bikeProfile, BuildContext context) async {
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
}

void barCodeFound(Barcode? code, QrCodeProvider qrCode,
    BikeProfileProvider bikeProfile, BuildContext context) async {
  qrCode.result = code;
  if (qrCode.result != null &&
      !bikeProfile.isViewingScanPage &&
      qrCode.canScan) {
    qrCode.canScan = false;
    showBikeDetailScanPage(int.tryParse(qrCode.result!.rawValue!) ?? 0, qrCode,
            bikeProfile, context)
        .then(() => {qrCode.canScan = true});
  }
}

class RRectQrCodeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    RRect rounded = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: 300,
            height: 300),
        const Radius.circular(50));
    path.addRRect(rounded);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(RRectQrCodeClipper oldClipper) => false;
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
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Center(
            child: MobileScanner(
          allowDuplicates: true,
          fit: BoxFit.fitHeight,
          controller: controller,
          onDetect: (barcode, args) {
            if (barcode.rawValue != null) {
              barCodeFound(barcode, ref.read(qrCodeProvider),
                  ref.watch(bikeProfileProvider), context);
            } else {
              log.e('Failed to scan Barcode');
            }
          },
          // ),
        )),
      ],
    );
  }
}
