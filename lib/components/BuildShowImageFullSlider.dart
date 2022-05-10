import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/globalStyles.dart' as GlobalStyles;

// Url server
import 'package:velyvelo/services/http_service.dart';

class SliderShowFullmages extends StatefulWidget {
  final List listImagesModel;
  final int current;
  final String mode;
  const SliderShowFullmages(
      {Key? key,
      required this.listImagesModel,
      required this.current,
      required this.mode})
      : super(key: key);
  @override
  _SliderShowFullmagesState createState() => _SliderShowFullmagesState();
}

class _SliderShowFullmagesState extends State<SliderShowFullmages> {
  int _current = 0;
  bool _stateChange = false;
  @override
  void initState() {
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _current = (_stateChange == false) ? widget.current : _current;
    return new Container(
        color: Colors.transparent,
        child: new Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: GlobalStyles.backgroundLightGrey,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: GlobalStyles.backgroundDarkGrey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: false,
                        height: MediaQuery.of(context).size.height / 1.3,
                        viewportFraction: 1.0,
                        onPageChanged: (index, data) {
                          setState(() {
                            _stateChange = true;
                            _current = index;
                          });
                        },
                        initialPage: widget.current),
                    items: map<Widget>(widget.listImagesModel, (index, url) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0.0)),
                                  child: widget.mode == "Network"
                                      ? Image.network(
                                          HttpService.urlServer + url,
                                          fit: BoxFit.fill,
                                          height: 400.0,
                                        )
                                      : widget.mode == "File"
                                          ? Image.file(
                                              url,
                                              fit: BoxFit.fill,
                                              height: 400.0,
                                            )
                                          : widget.mode == "Asset"
                                              ? Image.asset(
                                                  url,
                                                  fit: BoxFit.fill,
                                                  height: 400.0,
                                                )
                                              : SizedBox()),
                            )
                          ]);
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(widget.listImagesModel, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 9.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_current == index)
                              ? GlobalStyles.blue
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            )));
  }
}
