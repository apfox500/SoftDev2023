import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;

Future<ImageData> getDataFromImageAnalyzer(base64String) async {
  //cant use local server
  //must pass a url that points to a live, deployed server

  Map data = {
    "imageBase64": base64String
  };

  final body_ = json.encode(data);

  final resp = await http.post(
      Uri.parse('https://koda-80dc1.uc.r.appspot.com/analyze'),
      headers: {"Content-Type": "application/json"},
      body: body_);

  var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;

  if (resp.statusCode == 200) {
    return ImageData.fromJson(decodedResponse);
  } else {
    throw Exception('Failed to process image');
  }
}

class ImageData {
  final String Response;
  final int ResponseLength;
  final String PostMessage;

  const ImageData({required this.Response, required this.ResponseLength, required this.PostMessage});

  factory ImageData.fromJson(Map<dynamic, dynamic> json_Data) {
    return ImageData(
      Response: json_Data["response"],
      ResponseLength: json_Data["responseLength"],
      PostMessage: json_Data["ambussin"]
      );
  }

  // @override
  // String toString() {
  //   return StringLength;
  // }

  dynamic printObj() {
    return {'length': ResponseLength, 'pm': PostMessage};
  }
}
