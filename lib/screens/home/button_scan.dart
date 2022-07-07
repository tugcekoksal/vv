// Vendor
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Helpers

// Global Styles like colors
import 'package:velyvelo/screens/views/my_bikes/top_options.dart';
import 'package:velyvelo/screens/views/scan_view.dart';

class ButtonScan extends StatelessWidget {
  const ButtonScan({Key? key}) : super(key: key);

  Future<void> displayScan() async {
    Get.to(() => const Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: ScanView()));
  }

  @override
  Widget build(BuildContext context) {
    return TopButton(
        actionFunction: displayScan,
        isLoading: false,
        iconButton: Icons.qr_code_scanner);
  }
}
