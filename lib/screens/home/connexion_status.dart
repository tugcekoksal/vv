
import 'package:flutter/material.dart';
import 'package:velyvelo/config/api_request.dart';
//INTERNET CONNECTION
import 'dart:async';
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:http/http.dart' as http;

class ConnexionStatus extends StatefulWidget {
  const ConnexionStatus({super.key});

  @override
  State<ConnexionStatus> createState() => _ConnexionStatusState();
}

class _ConnexionStatusState extends State<ConnexionStatus> {
  bool hasInternetAccess = true;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _checkInternetAccess());
  }

  Future<void> _checkInternetAccess() async {
    bool newHasInternetAccess = true;

    try {
      final result = await http.get(
          Uri.parse('https://dns.google.com/resolve?name=example.com&type=A'));
      if (result.statusCode == 200) {
        newHasInternetAccess = true;
      } else {
        newHasInternetAccess = false;
      }
    } catch (_) {
      newHasInternetAccess = false;
    }
    if (newHasInternetAccess != hasInternetAccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (newHasInternetAccess) {
        int saveNbrRequests = failedRequestFunctions.length;
        await FunctionsQueue.execute();
        if (saveNbrRequests > 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$saveNbrRequests  actions en mode hors ligne ont été envoyées au serveur'),
            backgroundColor: global_styles.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Vous êtes connecté à internet'),
            backgroundColor: global_styles.green,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Vous n'êtes pas connecté à internet"),
          backgroundColor: global_styles.orange,
        ));
      }
      hasInternetAccess = newHasInternetAccess;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
