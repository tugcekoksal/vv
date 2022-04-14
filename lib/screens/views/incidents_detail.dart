// Vendor
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';

// Controllers
import 'package:velyvelo/controllers/incident_controller.dart';
import 'package:velyvelo/controllers/login_controller.dart';

// Service Url
import 'package:velyvelo/services/http_service.dart';

// Components
import 'package:velyvelo/components/BuildShowImageFullSlider.dart';

// Labels to put on bike
var dropdownItemList = <String>["Rangé", "Utilisé", "Volé"];

class IncidentDetail extends StatelessWidget {
  IncidentDetail({Key? key, required this.incident}) : super(key: key);

  final incident;

  final IncidentController incidentController = Get.put(IncidentController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalStyles.backgroundLightGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 65.0,
          elevation: 0,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          title: Text(
            "Mes incidents",
            style: TextStyle(
                color: GlobalStyles.greyTitle,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 15.0),
            child: SvgPicture.asset("assets/logo.svg",
                height: 15.0, width: 15.0, fit: BoxFit.scaleDown),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                    child: Stack(alignment: Alignment.center, children: [
                      Text("Historique des incidents",
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w700)),
                      Positioned(
                          left: 25.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              incidentController.destroy();
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20.0,
                            ),
                          ))
                    ])),
                BuildIdentificationTile(
                  id: incident.veloName,
                  title: incident.incidentTypeReparation,
                  status: incident.incidentStatus,
                  location: incident.veloGroup,
                  date: incident.dateCreation,
                  interventionTime: incident.interventionTime,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Informations",
                          style: TextStyle(
                              color: GlobalStyles.purple,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 10.0),
                      incidentController.incidentDetailValue.value.groupe ==
                                  "" ||
                              incidentController
                                      .incidentDetailValue.value.groupe ==
                                  null
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: 'Groupe ',
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: incidentController
                                          .incidentDetailValue.value.groupe,
                                      style: TextStyle(
                                          color: GlobalStyles.lightGreyText)),
                                ],
                              ),
                            ),
                      SizedBox(height: 5.0),
                      RichText(
                        text: TextSpan(
                          text: 'Vélo ',
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                          children: <TextSpan>[
                            TextSpan(
                                text: valueIsNull(incidentController
                                    .incidentDetailValue.value.velo),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      incidentController.incidentDetailValue.value.batteries ==
                                  "" ||
                              incidentController
                                      .incidentDetailValue.value.batteries ==
                                  null
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: 'Batterie ',
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: incidentController
                                          .incidentDetailValue.value.batteries,
                                      style: TextStyle(
                                          color: GlobalStyles.lightGreyText)),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Incident(s)",
                          style: TextStyle(
                              color: GlobalStyles.purple,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          text: "Type d'incident ",
                          style: TextStyle(
                              color: GlobalStyles.greyText,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700),
                          children: <TextSpan>[
                            TextSpan(
                                text: valueIsNull(incidentController
                                    .incidentDetailValue.value.typeIncident),
                                style: TextStyle(
                                    color: GlobalStyles.lightGreyText)),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      incidentController
                                  .incidentDetailValue.value.commentaire ==
                              null
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: 'Commentaire associé : ',
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: incidentController
                                          .incidentDetailValue
                                          .value
                                          .commentaire,
                                      style: TextStyle(
                                          color: GlobalStyles.lightGreyText)),
                                ],
                              ),
                            ),
                      SizedBox(height: 5.0),
                      RichText(
                        text: TextSpan(
                            text: 'Photos ',
                            style: TextStyle(
                                color: GlobalStyles.greyText,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(height: 10.0),
                      incidentController.incidentDetailValue.value.photos ==
                                  null ||
                              incidentController.incidentDetailValue.value
                                      .photos!.length ==
                                  0
                          ? Text(
                              "Cet incident ne contient aucune photo",
                              style: TextStyle(
                                  color: GlobalStyles.lightGreyText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700),
                            )
                          : GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 5,
                              children: incidentController
                                          .incidentDetailValue.value.photos ==
                                      null
                                  ? <String>[]
                                      .map((e) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      SliderShowFullmages(
                                                          mode: "Network",
                                                          listImagesModel:
                                                              incidentController
                                                                  .incidentDetailValue
                                                                  .value
                                                                  .photos!,
                                                          current:
                                                              incidentController
                                                                  .currentImageIndexInViewer
                                                                  .value)));
                                            },
                                            child: Image.asset(
                                              e,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          )))
                                      .toList()
                                  : incidentController
                                      .incidentDetailValue.value.photos!
                                      .map((image) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        SliderShowFullmages(
                                                            mode: "Network",
                                                            listImagesModel:
                                                                incidentController
                                                                    .incidentDetailValue
                                                                    .value
                                                                    .photos!,
                                                            current:
                                                                incidentController
                                                                    .currentImageIndexInViewer
                                                                    .value)));
                                              },
                                              child: Image.network(
                                                HttpService.urlServer + image,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                            )
                    ],
                  ),
                ),
                Obx(() {
                  if (loginController.isAdminOrTech.value) {
                    return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 20.0),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Réparations",
                                style: TextStyle(
                                    color: GlobalStyles.purple,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 10.0),
                            Text("Le vélo est-il fonctionnel ?",
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => incidentController
                                        .setCurrentDetailBikeStatus(true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          color: incidentController
                                                  .isBikeFunctional.value
                                              ? GlobalStyles.backgroundLightGrey
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: GlobalStyles
                                                  .backgroundLightGrey,
                                              width: 3.0)),
                                      child: Text("Oui",
                                          style: TextStyle(
                                              color: GlobalStyles.greyText,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                }),
                                Obx(() {
                                  return GestureDetector(
                                    onTap: () => incidentController
                                        .setCurrentDetailBikeStatus(false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          color: incidentController
                                                  .isBikeFunctional.value
                                              ? Colors.white
                                              : GlobalStyles
                                                  .backgroundLightGrey,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: GlobalStyles
                                                  .backgroundLightGrey,
                                              width: 3.0)),
                                      child: Text("Non",
                                          style: TextStyle(
                                              color: GlobalStyles.greyText,
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                })
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Text("Séléctionner le statut du vélo",
                                style: TextStyle(
                                    color: GlobalStyles.greyText,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 20.0),
                            // BuildDropDown(
                            //   placeholder: "Statut du vélo",
                            //   dropdownItemList: incidentController.incidentDetailValue.value.actualStatus,
                            //   setItem:
                            //       incidentController.setBikeStatus,
                            // ),
                            DropDownIncidentDetail(
                                incidentController: incidentController),
                            SizedBox(height: 10)
                          ],
                        ));
                  } else {
                    return SizedBox();
                  }
                }),
                SizedBox(height: 10)
              ],
            ),
          ),
        ));
  }
}

class DropDownIncidentDetail extends StatelessWidget {
  const DropDownIncidentDetail({
    Key? key,
    required this.incidentController,
  }) : super(key: key);

  final IncidentController incidentController;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          textTheme: TextTheme(
        subtitle1: TextStyle(
            color: GlobalStyles.greyTextInput,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: "Montserrat"),
      )),
      child: DropdownSearch<String>(
          mode: Mode.MENU,
          showSelectedItems: true,
          showSearchBox: true,
          dropdownSearchDecoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(15.0, 0.0, 2.0, 0.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    color: GlobalStyles.backgroundLightGrey, width: 3.0)),
            errorStyle: TextStyle(
                color: GlobalStyles.purple,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
            hintText: "Statut du vélo",
            hintStyle: TextStyle(
                color: GlobalStyles.greyTextInput,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
          ),
          popupElevation: 8,
          popupItemBuilder: (BuildContext context, item, bool isSelected) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: !isSelected
                  ? null
                  : BoxDecoration(
                      // border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.white,
                      color: GlobalStyles.backgroundLightGrey),
              child: ListTile(
                // selected: isSelected,
                title: Text(item,
                    style: TextStyle(color: GlobalStyles.greyTextInput)),
              ),
            );
          },
          emptyBuilder: (context, searchEntry) => Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: GlobalStyles.yellow,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Icon(
                      Icons.search_off_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Aucun résultats",
                    style: TextStyle(
                        color: GlobalStyles.backgroundDarkGrey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )),
          popupShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                  color: GlobalStyles.backgroundLightGrey, width: 1.5)),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: GlobalStyles.backgroundLightGrey, width: 2.5)),
              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
              hintText: "Rechercher",
              hintStyle: TextStyle(
                  color: GlobalStyles.greyTextInput,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          selectedItem: incidentController.currentStatusBike.value,
          items: incidentController.incidentDetailValue.value.status,
          onChanged: (value) {
            incidentController.setBikeStatus(value);
          }),
    );
  }
}

class BuildIdentificationTile extends StatelessWidget {
  final String? title;
  final String? status;
  final String? location;
  final String? id;
  final String? date;
  final int interventionTime;
  const BuildIdentificationTile(
      {Key? key,
      required this.title,
      required this.status,
      required this.location,
      required this.id,
      required this.date,
      required this.interventionTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title == null ? "No data" : title!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: status == null
                          ? GlobalStyles.greyLogin
                          : colorBasedOnIncidentStatus(status!),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(valueIsNull(status),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800))),
              )
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Flexible(
                child: Text(location == null ? "Aucun groupe" : location!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              ),
              Text(" - ",
                  style: TextStyle(
                      color: GlobalStyles.purple,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600)),
              Flexible(
                child: Text(valueIsNull(id),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
          const SizedBox(height: 7.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(valueIsNull(date),
                  style: TextStyle(
                      color: GlobalStyles.green,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.schedule,
                    color: GlobalStyles.purple,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    (interventionTime != 0
                            ? interventionTime.toString()
                            : "moins d'1") +
                        'h',
                    style: TextStyle(
                        color: GlobalStyles.purple,
                        fontWeight: FontWeight.w700),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
