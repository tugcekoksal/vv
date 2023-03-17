import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/controllers/incident_provider/incidents_provider.dart';

class SwitchStyle extends StatelessWidget {
  final String text;
  final bool isActive;

  const SwitchStyle({Key? key, required this.text, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isActive ? global_styles.backgroundLightGrey : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class SwitchIncidents extends ConsumerWidget {
  const SwitchIncidents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IncidentsProvider rProvider = ref.read(incidentsProvider);
    IncidentsProvider wProvider = ref.watch(incidentsProvider);

    return Positioned(
        top: 110,
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(
                onTap: () {
                  rProvider.swapView(View.listClient);
                },
                child: SizedBox(
                  height: 30,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: SwitchStyle(
                                text: "Mes incidents",
                                isActive:
                                    wProvider.view != View.historicIncident))
                      ]),
                )),
            GestureDetector(
                onTap: () {
                  rProvider.swapView(View.historicIncident);
                },
                child: SizedBox(
                    height: 30,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SwitchStyle(
                                  text: "Historique des incidents",
                                  isActive:
                                      wProvider.view == View.historicIncident))
                        ]))),
          ]),
        ));
  }
}
