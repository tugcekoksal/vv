// HttpService myServer = HttpService();

// void setMyMockHttpService() {
//   myServer = MockHttpService();
// }

// class MockTokenType {
//   static const String admin = "token-admin";
//   static const String client = "token-client";
//   static const String technicien = "token-technicien";
//   static const String utilisateur = "token-utilisateur";
//   static const String superUtilisateur = "token-superUtilisateur";
//   static const String error = "token-error";
// }

// class MockHttpService extends HttpService {
//   final log = logger(MockHttpService);

//   MockHttpService();

//   @override
//   Future<String> loginUser(String login, String password) async {
//     log.i("Call to: loginUser");
//     if (login.isEmpty) {
//       throw "Le champ identifiant ne peut être vide";
//     }
//     if (password.isEmpty) {
//       throw "Le champ mot de passe ne peut être vide";
//     }
//     if (password.length < 2) {
//       throw "Les informations fournies sont invalides";
//     }
//     return login;
//   }

//   @override
//   Future addDeviceToken(String userToken) async {
//     log.i("Call to: addDeviceToken");
//   }

//   @override
//   Future fetchTypeUser(String userToken) async {
//     log.i("Call to: fetchTypeUser");
//     switch (userToken) {
//       case MockTokenType.admin:
//         return "Admin";
//       case MockTokenType.client:
//         return "Client";
//       case MockTokenType.utilisateur:
//         return "Utilisateur";
//       case MockTokenType.superUtilisateur:
//         return "SuperUser";
//       case MockTokenType.technicien:
//         return "Technicien";
//     }
//     throw ("No role assigned");
//   }

//   @override
//   Future fetchAllIncidents(
//       RefreshIncidentModel incidentsToFetch, String userToken) async {
//     log.i("Call to: fetchTypeUser");
//     if (userToken == MockTokenType.error) {
//       throw Exception("No data currently available s");
//     }
//     return [
//       IncidentsModel(
//           nbIncidents: NbIncidents(enCours: 1, termine: 0, nouvelle: 0),
//           incidents: [
//             Incident(
//                 incidentTypeReparation: "incidentTypeReparation",
//                 incidentStatus: "incidentStatus",
//                 incidentPk: "incidentPk",
//                 veloGroup: "veloGroup",
//                 veloName: "veloName",
//                 dateCreation: "dateCreation",
//                 interventionTime: 0,
//                 reparationNumber: "reparationNumber")
//           ])
//     ];
//   }
// }
