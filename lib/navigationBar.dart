import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'configForm.dart';
import 'fetchServerMessage.dart';
import 'messageBlock.dart';

class navigationBar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: navigationBarComponent(title: '导航栏'),
    );
  }
}

class navigationBarComponent extends StatefulWidget {
  navigationBarComponent({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _navigationBarComponentState createState() => _navigationBarComponentState();
}

class _navigationBarComponentState extends State<navigationBarComponent> {
  late int currentIndex;
  List<dynamic> serverMessage = [];
  List<Map<String, dynamic>> serverMessageMap = [];
  late Timer _timer;

  Map<String, dynamic> config = {};

  @override
  void initState() {
    super.initState();
    currentIndex = 0;


    _timer = Timer.periodic(Duration(milliseconds: 4000), (timer) {
      _getLocalFile()
          .then((file) => {config = json.decode(file.readAsStringSync())});
      if (config.length == 2) {
        fetchAlbum(config["key"], config["ipPort"]).then((value) => {
              setState(() {
                serverMessage = value;
                serverMessageMap.removeWhere((element) => true);
                for (int i = 0; i < serverMessage.length; i++) {
                  serverMessageMap.add(json.decode(serverMessage[i]["data"]));
                  serverMessageMap[i]["time"] = serverMessage[i]["time"];
                }
              })
            });
      }
    });
  }

  Future<File> _getLocalFile() async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/config.json');
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: aListOfServerInformation(
      //   serverMessage: this.serverMessage,
      //   serverMessageMap: serverMessageMap,
      // ),
      body: Container(
        color: Color.fromRGBO(30, 77, 58, 1),
        child: currentIndex == 0
            ? ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: serverMessageMap.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) => messageBlock.name(
                    this.serverMessage, this.serverMessageMap, index),
              )
            : FormTestRoute(),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: Color.fromRGBO(30, 77, 58, 1),
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        //border radius doesn't work when the notch is enabled.
        elevation: 8,
        tilesPadding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
            showBadge: true,
            badge: Text(serverMessageMap.length.toString()),
            badgeColor: Color.fromRGBO(178, 89, 47, 1),
            backgroundColor: Color.fromRGBO(195, 161, 120, 1),
            icon: Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.dashboard,
              color: Color.fromRGBO(195, 161, 120, 1),
            ),
            title: Text("主页"),
          ),
          BubbleBottomBarItem(
              backgroundColor: Color.fromRGBO(195, 161, 120, 1),
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.settings,
                color: Color.fromRGBO(195, 161, 120, 1),
              ),
              title: Text("设置")),
        ],
      ),
    );
  }
}
