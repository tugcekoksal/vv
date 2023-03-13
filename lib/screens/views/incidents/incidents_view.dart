// Vendor
import 'package:flutter/material.dart';

// Usefull
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/screens/views/incidents/components/app_bar_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/client_card.dart';
import 'package:velyvelo/screens/views/incidents/components/list_client.dart';
import 'package:velyvelo/screens/views/incidents/components/switch_incidents.dart';
import 'package:velyvelo/screens/views/incidents/components/title_incidents.dart';

class IncidentsView extends StatelessWidget {
  const IncidentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: global_styles.backgroundLightGrey,
        child: Stack(alignment: Alignment.topCenter, children: [
          AppBarIncidents(),
          const TitleIncidents(),
          const SwitchIncidents(),
          ListClient()
        ]));
  }
}
