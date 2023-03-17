// Vendor
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;

// Components
import 'package:velyvelo/components/qr_code_scanner.dart';
import 'package:velyvelo/controllers/bike_provider/bike_profile_provider.dart';
import 'package:velyvelo/screens/views/bike_detail_scan.dart';

// Controllers
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class InputNumeroCadran extends StatelessWidget {
  final TextEditingController controller;

  const InputNumeroCadran({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
          top: 5),
      child: TextField(
        textAlign: TextAlign.center,
        maxLength: 100,
        autocorrect: false,
        autofocus: false,
        onChanged: (e) => {controller.text = e},
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          hintText: "Numéro cadran du vélo",
          hintStyle: const TextStyle(
              color: global_styles.greyLogin,
              fontSize: 12.0,
              fontWeight: FontWeight.w700),
          contentPadding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
      ),
    );
  }
}

class HintScanQrCode extends StatelessWidget {
  const HintScanQrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.15, vertical: 5),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.white),
          child: const Text(
              "Veuillez scanner le QR code d'un vélo afin d'ouvrir sa fiche technique.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: global_styles.purple,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400))),
    );
  }
}

class ScanView extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();

  ScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BikeProfileProvider bikeProfile = ref.watch(bikeProfileProvider);
    return ColorfulSafeArea(
        color: Colors.white,
        child: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: QRCodeScanner()),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReturnBar(text: "Scannez un vélo"),
                  Column(
                    children: [
                      const HintScanQrCode(),
                      InputNumeroCadran(controller: controller),
                      IconButton(
                        onPressed: () {
                          bikeProfile
                              .fetchUserBike(nomVelo: controller.text)
                              .then((value) {
                            if (bikeProfile.messageError == "") {
                              bikeProfile.isViewingScanPage = true;
                              Get.off(() => const BikeDetailScan(),
                                  transition: Transition.downToUp,
                                  duration: const Duration(milliseconds: 400));
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              const snackBar = SnackBar(
                                  content: Text(
                                      'Vous n\'avez pas accès aux données de ce vélo.'),
                                  backgroundColor: Colors.red);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          });
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              )),
        ]));
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height;
    double sw = size.width;
    double cornerSide = sh * 0.2;

    Paint paint = Paint()
      ..color = Colors.white60
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
