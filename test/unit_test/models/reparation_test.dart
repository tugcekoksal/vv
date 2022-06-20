// Vendor
import 'package:flutter_test/flutter_test.dart';
import 'package:velyvelo/models/incident/incident_detail_model.dart';
import 'package:velyvelo/models/json_usefull.dart';

// Usefull
import '../usefull/json_file_to_json.dart';

void isIdAndNameEmpty(IdAndName data, bool isEmpty) {
  if (isEmpty) {
    expect(data.id, null);
    expect(data.name, null);
  } else {
    expect(data.id, isNot(null));
    expect(data.name, isNot(null));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test("reparation infos missing", () async {
    final jsonData =
        await jsonFileToJson("reparation_test/missing_fields_response.json");
    final ReparationModel incidentDetail =
        ReparationModel.fromJson(jsonData, null, []);
    expect(incidentDetail.statusBike, null);
    expect(incidentDetail.isBikeFunctional, null);
    expect(incidentDetail.incidentPk, null);
    isIdAndNameEmpty(incidentDetail.cause, true);
    expect(incidentDetail.causelist, []);
    isIdAndNameEmpty(incidentDetail.typeIntervention, true);
    expect(incidentDetail.typeInterventionList, []);
    isIdAndNameEmpty(incidentDetail.typeReparation, true);
    expect(incidentDetail.typeReparationList, []);
    expect(incidentDetail.selectedPieces, []);

    // Used in front to stock the availables pieces
    expect(incidentDetail.piecesList, []);
    // Given by the front, can t be null
    expect(incidentDetail.reparationPhotosList, []);
    // Never null because text controller put "" if null
    expect(incidentDetail.commentaryTech.text, "");
    expect(incidentDetail.commentaryAdmin.text, "");
    // Filled only when the user select a piece in the dropdown
    isIdAndNameEmpty(incidentDetail.selectedPieceDropDown, true);
  });
  test("reparation infos invalids", () async {
    final jsonData =
        await jsonFileToJson("reparation_test/invalid_fields_response.json");
    final ReparationModel incidentDetail =
        ReparationModel.fromJson(jsonData, null, []);
    expect(incidentDetail.statusBike, null);
    expect(incidentDetail.isBikeFunctional, null);
    expect(incidentDetail.incidentPk, null);
    isIdAndNameEmpty(incidentDetail.cause, true);
    expect(incidentDetail.causelist, []);
    isIdAndNameEmpty(incidentDetail.typeIntervention, true);
    expect(incidentDetail.typeInterventionList, []);
    isIdAndNameEmpty(incidentDetail.typeReparation, true);
    expect(incidentDetail.typeReparationList, []);
    expect(incidentDetail.selectedPieces, []);

    // Used in front to stock the availables pieces
    expect(incidentDetail.piecesList, []);
    // Given by the front, can t be null
    expect(incidentDetail.reparationPhotosList, []);
    // Never null because text controller put "" if null
    expect(incidentDetail.commentaryTech.text, "");
    expect(incidentDetail.commentaryAdmin.text, "");
    // Filled only when the user select a piece in the dropdown
    isIdAndNameEmpty(incidentDetail.selectedPieceDropDown, true);
  });
  test("reparation infos valids", () async {
    final jsonData =
        await jsonFileToJson("reparation_test/valid_fields_response.json");
    final ReparationModel incidentDetail =
        ReparationModel.fromJson(jsonData, 0, []);
    expect(incidentDetail.statusBike, isNot(null));
    expect(incidentDetail.isBikeFunctional, isNot(null));
    expect(incidentDetail.incidentPk, isNot(null));
    isIdAndNameEmpty(incidentDetail.cause, false);
    expect(incidentDetail.causelist, isNot([]));
    isIdAndNameEmpty(incidentDetail.typeIntervention, false);
    expect(incidentDetail.typeInterventionList, isNot([]));
    isIdAndNameEmpty(incidentDetail.typeReparation, false);
    expect(incidentDetail.typeReparationList, isNot([]));
    expect(incidentDetail.selectedPieces, isNot([]));

    // Used in front to stock the availables pieces
    expect(incidentDetail.piecesList, []);
    // Given by the front, can t be null
    expect(incidentDetail.reparationPhotosList, []);
    // Never null because text controller put "" if null
    expect(incidentDetail.commentaryTech.text, isNot(""));
    expect(incidentDetail.commentaryAdmin.text, isNot(""));
    // Filled only when the user select a piece in the dropdown
    isIdAndNameEmpty(incidentDetail.selectedPieceDropDown, true);
  });
}
