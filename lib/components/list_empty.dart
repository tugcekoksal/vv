import 'package:flutter/material.dart';
import 'package:velyvelo/config/global_styles.dart' as global_styles;

class ListEmpty extends StatelessWidget {
  final String text;

  const ListEmpty({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_box_rounded,
              color: global_styles.green,
              size: 50,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: global_styles.backgroundDarkGrey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
