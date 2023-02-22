import 'dart:convert';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;

Future<ImageData> getDataFromImageAnalyzer(base64String) async {
  //cant use local server
  //must pass a url that points to a live, deployed server

  Map data = {"imageBase64": base64String};

  final body_ = json.encode(data);

  final resp = await http.post(
      Uri.parse('https://koda-80dc1-m7mjyb4lxa-uc.a.run.app/analyze'),
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
  final String Libraries;
  final String VariablesDeclared;
  final String UnrecognizedData;
  final String PostMessage;

  const ImageData(
      {required this.Libraries,
      required this.VariablesDeclared,
      required this.UnrecognizedData,
      required this.PostMessage});

  factory ImageData.fromJson(Map<dynamic, dynamic> json_Data) {
    return ImageData(
        Libraries: json_Data["Libraries"],
        VariablesDeclared: json_Data["VariablesDeclared"],
        UnrecognizedData: json_Data["UnrecognizedData"],
        PostMessage: json_Data["ambussin"]);
  }

  // @override
  // String toString() {
  //   return StringLength;
  // }

  dynamic printObj() {
    return {
      'Libraries': Libraries,
      'VariablesDeclared': VariablesDeclared,
      'UnrecognizedData': UnrecognizedData,
      'Post_Message': PostMessage
    };
  }
}