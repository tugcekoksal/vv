// Vendor
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Helpers
import 'package:velyvelo/helpers/ifValueIsNull.dart';
import 'package:velyvelo/helpers/statusColorBasedOnStatus.dart';

class HeaderContainer extends StatelessWidget {
  final String? title;
  final String? status;
  final String? location;
  final String? id;
  final String? date;
  final int interventionTime;
  const HeaderContainer(
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
