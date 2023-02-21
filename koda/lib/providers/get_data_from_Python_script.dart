import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<ImageData> getDataFromImageAnalyzer(base64String) async {
  //cant use local server
  //must pass a url that points to a live, deployed server
  final resp = await http.get(Uri.parse("https://httpbin.org/ip"));
  dynamic jsonAppData = convert.jsonDecode(resp.body);

  if (resp.statusCode == 200) {
    return ImageData.fromJson(jsonAppData);
  } else {
    throw Exception('Failed to process image');
  }
}

class ImageData {
  final String StringLength;

  const ImageData({required this.StringLength});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(StringLength: json["origin"]);
  }

  @override
  String toString() {
    return StringLength;
  }
}
