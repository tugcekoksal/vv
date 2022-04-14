// Vendor
import 'package:http/http.dart' as http;

// Models
import 'package:velyvelo/models/labels/client_labels_model.dart';

Future<List<ClientLabelsListModel>> fetchClientLabelsByUserService(
    String urlServer, String userToken) async {
  var response = await http.get(Uri.parse("$urlServer/api/clientListByUser/"),
      headers: {"Authorization": 'Token $userToken'});
  if (response.statusCode == 200) {
    var clientLabels = response.body;
    return clientLabelsListModelFromJson(clientLabels);
  } else {
    throw Exception();
  }
}
