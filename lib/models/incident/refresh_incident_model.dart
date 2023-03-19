import 'package:velyvelo/models/json_usefull.dart';

class RefreshIncidentModel {
  RefreshIncidentModel({
    required this.statusList,
    required this.clientList,
    required this.groupList,
    this.newestId,
    this.count,
  });

  List<String> statusList;
  List<IdAndName> clientList;
  List<IdAndName> groupList;

  int? newestId;
  int? count;

  Map<String, dynamic> toJson(String search) => {
        "status_list": List<dynamic>.from(statusList.map((x) => x)),
        "client_list": List<int>.from(clientList.map((e) => e.id)),
        "group_list": List<int>.from(groupList.map((e) => e.id)),
        "search": search,
        if (newestId != null) "newest_id": newestId,
        if (count != null) "count": count,
      };
}
