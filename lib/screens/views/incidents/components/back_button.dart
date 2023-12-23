import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  final void Function()? onTap;
  const GoBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0, left: 20.0, right: 20.0),
        alignment: Alignment.center,
        width: 60,
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Text(
          "Retour",
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
