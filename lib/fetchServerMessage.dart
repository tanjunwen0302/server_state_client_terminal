import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client sslClient() {
  var ioClient = new HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  http.Client _client = IOClient(ioClient);
  return _client;
}

/*
* key:键值
* add:服务器ip与端口
* */
Future<List<dynamic>> fetchAlbum(String key, add) async {
  Uri uri=Uri.https(add,"/dataSending");
  Map<String,String> data={};
  data["key"]=key;

  final response = await sslClient().post(uri, body: json.encode(data));
  if(response.statusCode!=200){
    return  Future.value([]);
  }
  List<dynamic> list=json.decode(response.body);
  list.sort((a,b)=>Comparable.compare(a["username"].toString(), b["username"].toString()));
  return Future.value(list);
}
