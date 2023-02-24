/**
 * Packages imported
 */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<ImageData> getDataFromImageAnalyzer(base64String) async {
  ///Format the data into a Map with key/value pairs
  Map data = {"imageBase64": base64String};

  ///Actually encode the data into JSON format
  final body_ = json.encode(data);

  ///Make the HTTP Request
  ///Method: POST
  ///The URL points to the service URL of the Googlee Cloud deployed script
  ///Request pody contains the base64 string
  final resp = await http.post(
      Uri.parse('https://koda-80dc1-m7mjyb4lxa-uc.a.run.app/analyze'),
      headers: {"Content-Type": "application/json"},
      body: body_);

  ///Takes the response and decodes it into a JSON format. Casts it as a Map with Key/Value pairs
  var decodedResponse = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;

  ///Checks to ensure that the HTTPS request was successful
  if (resp.statusCode == 200) {
    ///Returns the data --> encoded into a specific format.
    ///Specific format is outlined below --> Custom Class
    return ImageData.fromJson(decodedResponse);
  } else {
    throw Exception('Failed to process image');
  }
}

/// Custom classes for processing and organizing data
class ImageData {
  final String libraries;
  final String VariablesDeclared;
  final String UnrecognizedData;
  final String PostMessage;
  final List<dynamic> Libs;

  /// Constructor for custom class
  const ImageData(
      {required this.libraries,
      required this.VariablesDeclared,
      required this.UnrecognizedData,
      required this.PostMessage,
      required this.Libs});

  ///Method to load in the data of the response into the custom class
  factory ImageData.fromJson(Map<dynamic, dynamic> json_Data) {
    return ImageData(
        libraries: json_Data["Libraries"],
        VariablesDeclared: json_Data["VariablesDeclared"],
        UnrecognizedData: json_Data["UnrecognizedData"],
        Libs: json_Data['Libs'],
        //Libs: ["Pytesseract", "Numpy"],
        PostMessage: json_Data["ambussin"]);
  }

  ///Method for development/programmers
  ///Sort of toString method
  dynamic printObj() {
    return {
      'Libraries': libraries,
      'VariablesDeclared': VariablesDeclared,
      'UnrecognizedData': UnrecognizedData,
      'Libs': Libs,
      'Post_Message': PostMessage
    };
  }
}

///This is the method for querying the descriptions of all the detected libraries from Recognition
///It takes in a list of the Python Libraries recognized and returns a Promise of a List which contains Map object
Future<List<Map<String, String>>> getPythonLibraryDescription(
    List<dynamic> pythLib) async {
  List<Map<String, String>> ret = [];

  ///Reference to the collection of the Firestore database which contains all the module descriptions
  CollectionReference db =
      FirebaseFirestore.instance.collection("Python Libraries");

  for (var e in pythLib) {
    await db
        .doc((e as String).toLowerCase())
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        ret.add({'Lib': e, "Description": data["Description"]!});
      }
    });
  }

  return ret;
}
