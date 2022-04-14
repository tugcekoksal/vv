// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Components
import 'package:velyvelo/components/BuildQRCodeScanner.dart';

// Controllers
import 'package:velyvelo/controllers/bike_controller.dart';

class ScanView extends StatelessWidget {
  ScanView({Key? key}) : super(key: key);

  final BikeController bikeController = Get.put(BikeController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                child: Text(
                  "Scannez un vélo",
                  style: TextStyle(
                      color: GlobalStyles.greyText,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 20.0),
            Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: BuildQRCodeScanner())),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15),
              child: Text(
                  "Veuillez scanner le QR code d’un vélo afin d’ouvrir sa fiche technique.",
                  style: TextStyle(
                      color: GlobalStyles.purple,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
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
