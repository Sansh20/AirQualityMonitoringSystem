import 'package:airqualitymonitor/services/sensor_data.dart';
import 'package:airqualitymonitor/theme/gruv_colors.dart';
import 'package:airqualitymonitor/widgets/details_comp.dart';
import 'package:flutter/material.dart';

class HistoricalDataComponent extends StatefulWidget {
  final Map<int, Map<String, dynamic>> histData;
  // final Function onPressed;
  const HistoricalDataComponent({
    super.key,
    required this.histData,
    /*required this.onPressed*/
  });

  @override
  State<HistoricalDataComponent> createState() =>
      _HistoricalDataComponentState();
}

class _HistoricalDataComponentState extends State<HistoricalDataComponent> {
  OverlayEntry? overlayEntry;
  var keyMap = <int, GlobalKey>{};

  void generateKeys() {
    List<int> keyList = widget.histData.keys.toList()..sort();
    for (int i = 0; i < widget.histData.length; i++) {
      keyMap[keyList[i]] = GlobalKey();
    }
  }

  double? _x, _y;
  Map<String, List<dynamic>> detailsMap = {};
  List<String> mapKeysInOrder = [];

  void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }

  void showOverlay(BuildContext context, SensorData data) async {
    OverlayState overlayState = Overlay.of(context)!;
    removeOverlay();
    mapKeysInOrder = data.mapKeysInOrder;
    detailsMap = data.getMap();
    assert(overlayEntry == null);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          left: _x! - 15,
          top: _y! + 90,
          child: Container(
            height: 290,
            width: 160,
            decoration: const BoxDecoration(
              color: GruvColors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: DetailComponent(
                    magnitude: data.aqi.ceil().toDouble(),
                    magStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: GruvColors.colorMap[data.getRange()],
                        fontSize: 26),
                    sideText: "aqi",
                    sideTextStyle: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(
                            color: GruvColors.colorMap[data.getRange()],
                            fontSize: 10),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(mapKeysInOrder.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        //padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                            color: Color(0xFF504945),
                            width: 0.5,
                          )),
                        ),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mapKeysInOrder[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontSize: 15),
                            ),
                            Text(
                              "${detailsMap[mapKeysInOrder[index]]![0].ceil()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ));
    });
    overlayState.insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    List<int> keyList = widget.histData.keys.toList()..sort();

    generateKeys();
    var size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: size.width - 30,
        // margin: const EdgeInsets.symmetric(horizontal: 15),
        height: size.height / 5.5,
        decoration: const BoxDecoration(
          color: GruvColors.brown,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: List.generate(keyList.length, (index) {
            return Stack(children: [
              Container(
                key: keyMap[keyList[index]],
                width: 110,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.histData[keyList[index]]!["isTapped"] =
                          !widget.histData[keyList[index]]!["isTapped"];
                    });
                    _getOffset(keyMap[keyList[index]]!);
                    if (widget.histData[keyList[index]]!["isTapped"]) {
                      showOverlay(context,
                          widget.histData[keyList[index]]!["sensorData"]);
                    } else {
                      removeOverlay();
                    }
                    // widget.onPressed();
                  },
                  child: DetailComponent(
                    magnitude: widget
                        .histData[keyList[index]]!["sensorData"].aqi
                        .ceil(),
                    title: "${keyList[index]} Day(s) Ago",
                    magStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: GruvColors.colorMap[widget
                            .histData[keyList[index]]!["sensorData"]
                            .getRange()]),
                    titleStyle: Theme.of(context).textTheme.headline3!.copyWith(
                          color: GruvColors.offWhite,
                        ),
                  ),
                ),
              ),
            ]);
          })),
        ));

    // }),
    // );
  }
}

        // child: ListView.builder(
        //     itemExtent: 80,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 10,
        //     shrinkWrap: true,
        //     itemBuilder: (BuildContext context, index) {
        //       return