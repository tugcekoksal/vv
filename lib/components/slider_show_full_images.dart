import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Global Styles like colors
import 'package:velyvelo/config/global_styles.dart' as global_styles;
import 'package:velyvelo/config/url_to_file.dart';

// Url server
import 'package:velyvelo/services/http_service.dart';

class SliderShowFullImages extends StatefulWidget {
  final List listImagesModel;
  final int current;
  final String mode;
  const SliderShowFullImages(
      {super.key,
      required this.listImagesModel,
      required this.current,
      required this.mode});
  @override
  _SliderShowFullImagesState createState() => _SliderShowFullImagesState();
}

class _SliderShowFullImagesState extends State<SliderShowFullImages> {
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
    return Container(
        color: Colors.transparent,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: global_styles.backgroundLightGrey,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: global_styles.backgroundDarkGrey),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: false,
                      height: MediaQuery.of(context).size.height / 1.4,
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
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0.0)),
                              child: widget.mode == "Network"
                                  ? Image.network(
                                      HttpService.urlServer + url,
                                      fit: BoxFit.fill,
                                      height: 500.0,
                                    )
                                  : widget.mode == "File"
                                      ? Image.file(
                                          url,
                                          fit: BoxFit.fill,
                                          height: 500.0,
                                        )
                                      : widget.mode == "Asset"
                                          ? Image.asset(
                                              url,
                                              fit: BoxFit.fill,
                                              height: 500.0,
                                            )
                                          : const SizedBox())
                        ]);
                  }),
                ),
                GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Téléchargement...'),
                          backgroundColor: Colors.blue));
                      saveImageFromUrl(HttpService.urlServer +
                              widget.listImagesModel[_current])
                          .then((value) => {
                                ScaffoldMessenger.of(context).clearSnackBars(),
                                if (value == null)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'La photo n\'a pas été téléchargé'),
                                            backgroundColor: Colors.red)),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(value),
                                            backgroundColor: Colors.green)),
                                  }
                              });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Télécharger la photo",
                          style: TextStyle(
                              color: global_styles.black75,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.download,
                          size: 30,
                        )
                      ],
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(widget.listImagesModel, (index, url) {
                    return Container(
                      width: 10.0,
                      height: 9.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_current == index)
                            ? global_styles.blue
                            : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            )));
  }
}
