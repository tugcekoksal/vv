// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as global_styles;

// Components
import 'package:velyvelo/components/BuildQRCodeScanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';
import 'package:velyvelo/screens/views/incident_detail/return_container.dart';

class ScanView extends StatelessWidget {
  ScanView({Key? key}) : super(key: key);

  final BikeController bikeController = Get.put(BikeController());

  void init() {
    bikeController.error.value = "";
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.075),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15),
              child: const ReturnContainer(text: "Scannez un vélo")),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.7,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: const BuildQRCodeScanner())),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: const Text(
                "Veuillez scanner le QR code d’un vélo afin d’ouvrir sa fiche technique.",
                style: TextStyle(
                    color: global_styles.purple,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
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
