import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class messageBlock extends StatefulWidget {
  messageBlock({super.key});

  List<dynamic> serverMessage = [];
  List<Map<String, dynamic>> serverMessageMap = [];
  int index = 0;

  messageBlock.name(this.serverMessage, this.serverMessageMap, this.index);

  @override
  State createState() => _messageBlockState(
      serverMessage: this.serverMessage,
      serverMessageMap: this.serverMessageMap,
      index: this.index);
}

class _messageBlockState extends State<messageBlock> {
  List<dynamic> serverMessage = [];
  List<Map<String, dynamic>> serverMessageMap = [];
  int index = 0;

  _messageBlockState(
      {required this.serverMessage,
      required this.serverMessageMap,
      required this.index});

  ///声明变量
  late Timer _timer;

  Widget _cpuCoreOccupancyDetails() {
    List<Widget> list = [];
    int CoreNum = serverMessageMap[index]["cpu"]["num"];
    int added = 0;
    for (int i = 0; i < (CoreNum / 4).ceil(); i++) {
      List<Widget> r = [];
      for (int a = 0; a < 4 && added < CoreNum; a++) {
        r.add(new Column(
          children: [
            new CircularPercentIndicator(
                radius: 20,
                lineWidth: 5,
                percent: serverMessageMap[index]["cpu"]
                        ["core" + added.toString()] /
                    100,
                center: new Text(
                  serverMessageMap[index]["cpu"]["core" + added.toString()]
                          .toStringAsFixed(1) +
                      "%",
                  style: TextStyle(fontSize: 10),
                ),
                progressColor: Color.fromRGBO(30, 77, 58, 1),
                backgroundColor: Color.fromRGBO(195, 161, 120, 1)),
            Text("core" + added.toString(), style: TextStyle(fontSize: 13))
          ],
        ));
        added++;
      }
      Row row = new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: r,
      );

      list.add(row);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(178, 89, 47, 1)),
      child: Column(
        children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Color.fromRGBO(195, 161, 120, 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(serverMessageMap[index]["client"]["username"]),
                Text(serverMessageMap[index]["client"]["ip"]
                    .toString()
                    .split(":")[0]),
                Text(serverMessageMap[index]["host"]["os"])
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  new CircularPercentIndicator(
                      radius: 35,
                      lineWidth: 10,
                      percent: serverMessageMap[index]["cpu"]["percent"] / 100,
                      center: new Text(serverMessageMap[index]["cpu"]["percent"]
                              .toStringAsFixed(1) +
                          "%"),
                      progressColor: Color.fromRGBO(30, 77, 58, 1),
                      backgroundColor: Color.fromRGBO(195, 161, 120, 1)),
                  Text("cpu " +
                      serverMessageMap[index]["cpu"]["num"].toString() +
                      "t")
                ],
              ),
              Column(
                children: [
                  new CircularPercentIndicator(
                      radius: 35,
                      lineWidth: 10,
                      percent:
                          serverMessageMap[index]["mem"]["usedPercent"] / 100,
                      center: new Text(serverMessageMap[index]["mem"]
                                  ["usedPercent"]
                              .toStringAsFixed(1) +
                          "%"),
                      progressColor: Color.fromRGBO(30, 77, 58, 1),
                      backgroundColor: Color.fromRGBO(195, 161, 120, 1)),
                  Text("mem" +
                      "(" +
                      serverMessageMap[index]["mem"]["used"]
                          .toStringAsFixed(1) +
                      "/" +
                      serverMessageMap[index]["mem"]["total"]
                          .toStringAsFixed(1) +
                      ")")
                ],
              ),
              Column(
                children: [
                  new CircularPercentIndicator(
                    radius: 35,
                    lineWidth: 10,
                    percent: serverMessageMap[index]["disk"]["usage"] / 100,
                    center: new Text(serverMessageMap[index]["disk"]["usage"]
                            .toStringAsFixed(1) +
                        "%"),
                    progressColor: Color.fromRGBO(30, 77, 58, 1),
                    backgroundColor: Color.fromRGBO(195, 161, 120, 1),
                  ),
                  Text("disk" +
                      "(" +
                      serverMessageMap[index]["disk"]["used"]
                          .toStringAsFixed(0) +
                      "/" +
                      serverMessageMap[index]["disk"]["total"]
                          .toStringAsFixed(0) +
                      ")")
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _cpuCoreOccupancyDetails(),
          SizedBox(
            height: 10,
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("上传:" +
                    (serverMessageMap[index]["net"]["bytesSent"] /
                            1024 /
                            1024 /
                            1024)
                        .toStringAsFixed(1) +
                    "GB"),
                new LinearPercentIndicator(
                  width: 130,
                  lineHeight: 13,
                  percent: (serverMessageMap[index]["net"]["bytesSent"]) /
                      (serverMessageMap[index]["net"]["bytesSent"] +
                          serverMessageMap[index]["net"]["bytesRecv"]),
                  progressColor: Color.fromRGBO(30, 77, 58, 1),
                  backgroundColor: Color.fromRGBO(195, 161, 120, 1),
                ),
                Text("下载:" +
                    (serverMessageMap[index]["net"]["bytesRecv"] /
                            1024 /
                            1024 /
                            1024)
                        .toStringAsFixed(1) +
                    "GB")
              ]),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("tcp:" +
                  serverMessageMap[index]["net"]["tcp"].toString() +
                  "  udp:" +
                  serverMessageMap[index]["net"]["udp"].toString()),
              Text("运行：" +
                  serverMessageMap[index]["host"]["time"].toStringAsFixed(1) +
                  "天")
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("最后更新时间：" + serverMessageMap[index]["time"].toString()),
              SizedBox(
                width: 10,
              )
            ],
          )
        ],
      ),
    );
  }
}
