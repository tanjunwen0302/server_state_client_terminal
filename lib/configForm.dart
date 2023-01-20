import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FormTestRoute extends StatefulWidget {
  @override
  _FormTestRouteState createState() => _FormTestRouteState();
}

class _FormTestRouteState extends State<FormTestRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    _getLocalFile().then((value) {
      Map<String, dynamic> con = json.decode(value.readAsStringSync());
      _unameController.text = con["ipPort"];
      _pwdController.text = con["key"];
    });
  }

  GlobalKey _formKey = GlobalKey<FormState>();

  Future<File> _getLocalFile() async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return File('$dir/config.json');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _unameController,
            decoration: InputDecoration(
              labelText: "IP地址与端口号",
              hintText: "例：127.0.0.1:4234",
              icon: Icon(Icons.person),
            ),
            // 校验
            validator: (v) {
              return v!.trim().isNotEmpty ? null : "ip地址与端口不能为空";
            },
          ),
          TextFormField(
            controller: _pwdController,
            decoration: InputDecoration(
              labelText: "key",
              hintText: "key",
              icon: Icon(Icons.lock),
            ),
            //校验密码
            validator: (v) {
              return v!.trim().isNotEmpty ? null : "key值不能为空";
            },
          ),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("保存"),
                    ),
                    onPressed: () {
                      // 通过_formKey.currentState 获取FormState后，
                      // 调用validate()方法校验用户名密码是否合法，校验
                      // 通过后再提交数据。
                      if ((_formKey.currentState as FormState).validate()) {
                        Map<String, String> config = {};
                        config["ipPort"] = _unameController.text;
                        config["key"] = _pwdController.text;
                        _getLocalFile().then((value) =>
                            {value.writeAsStringSync(json.encode(config))});
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
