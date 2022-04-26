// // Vendor
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:velyvelo/controllers/incident_controller.dart';
// import 'package:velyvelo/controllers/login_controller.dart';

// // Widgets to tests
// import 'package:velyvelo/screens/views/incident_detail/reparation/reparation_container.dart';
// import 'package:velyvelo/screens/views/incident_detail/reparation/statut_velo_modif.dart';

// // abstract class MockWithExpandedToString extends Mock {
// //   String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug});
// // }

// class MockReparationContainer extends Mock implements ReparationContainer {
//   @override
//   String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
//     return super.toString();
//   }
// }

// void main() {
//   late MockReparationContainer mockReparationContainer;

//   final LoginController loginController = LoginController();
//   final IncidentController incidentController = IncidentController();

//   setUp(() {
//     mockReparationContainer = MockReparationContainer();
//   });

//   testWidgets(
//     "text is displayed",
//     (WidgetTester tester) async {
//       tester.pumpWidget(MockReparationContainer());
//       expect(find.text("Oui"), findsOneWidget);
//     },
//   );
// }
