import 'package:flutter/material.dart';

import 'loading_box.dart';

class ListIsLoading extends StatelessWidget {
  const ListIsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return LoadingBox(
            child: Container(
                padding: const EdgeInsets.all(20.0),
                margin:
                    const EdgeInsets.only(bottom: 8.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                height: 100),
          );
        });
  }
}
