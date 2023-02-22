import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'dart:convert';

import '../../widgets/footer_buttons.dart';
import '../../models/global.dart';
import '../../providers/get_data_from_Python_script.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  //make each variable tht the script return an independednt state variable
  late String Libraries = "";
  late String VariablesDec = "";
  late String UnrecognizedData = "";
  List<dynamic> libs = [''];
  bool show = false;
  bool loadingState = false;

  @override
  Widget build(BuildContext context) {
    Global global = widget.global;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final ImagePicker picker = ImagePicker();

    return FlutterEasyLoading(
        child: Scaffold(
      backgroundColor: Global.davysGrey,
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "Translate",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "SpaceGrotesque",
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 108, 155, 238),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    "Welcome to the Translate Page! \n\nHere, Koda offers the ability to read and interpret other programs from photos. To get started, press the 'Take Photo' button below, get the desired code in frame, and take the photo.",
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading...');

                      XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);

                      /**
                       * Basically need to send the image to GCP
                       * GCP will run Chiranth's python script
                       * GCP will return a text file/JSON object for interpretation
                       */

                      List<int> imageBytes =
                          await photo?.readAsBytes() as List<int>;
                      String img64 = base64Encode(imageBytes);

                      //send base64 string to method that makes API call to GCP Python Script
                      final result = await getDataFromImageAnalyzer(img64);

                      setState(() {
                        Libraries = result.Libraries;
                        VariablesDec = result.VariablesDeclared;
                        UnrecognizedData = result.UnrecognizedData;
                        libs = result.Libs;
                        show = true;
                      });

                      EasyLoading.dismiss();

                      //print(result.printObj());
                    },
                    child: Text("Take Photo")),
                ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading...');

                      XFile? photo =
                          await picker.pickImage(source: ImageSource.gallery);

                      /**
                       * Basically need to send the image to GCP
                       * GCP will run Chiranth's python script
                       * GCP will return a text file/JSON object for interpretation
                       */

                      // getting a directory path for saving
                      // Io.Directory appDocumentsDirectory =
                      //     await getApplicationDocumentsDirectory(); // 1
                      // String appDocumentsPath = appDocumentsDirectory.path; // 2
                      // String filePath =
                      //     '$appDocumentsPath/demoTextFile.txt'; // 3

                      List<int> imageBytes =
                          await photo?.readAsBytes() as List<int>;
                      String img64 = base64Encode(imageBytes);
                      final result = await getDataFromImageAnalyzer(img64);
                      print(result.printObj());

                      EasyLoading.dismiss();

                      // copy the file to a new path
                      //final XFile newImage = await photo?.copy('$path/image1.png');
                    },
                    child: Text("Choose Image from Library")),
                Visibility(
                    visible: show,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 239, 190, 111),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            '$Libraries',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: libs.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 246, 211, 155),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Text(libs[i]),
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 25, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 239, 164, 111),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            VariablesDec,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 151, 197, 78),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            UnrecognizedData,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "Translate",
      ),
    ));
  }
}


//most ass program ever written
// //Shitty program stolen from an AI - feel free to use
// String translateToPseudocode(String pythonCode) {
//   // Remove leading and trailing whitespace from the Python code
//   pythonCode = pythonCode.trim();

//   // Split the Python code into a list of lines
//   List<String> lines = pythonCode.split('\n');

//   // Initialize a string to hold the pseudocode
//   String pseudocode = '';

//   // Loop through each line of the Python code
//   for (String line in lines) {
//     // Remove leading and trailing whitespace from the line
//     line = line.trim();

//     // Skip empty lines
//     if (line.isEmpty) {
//       continue;
//     }

//     // Translate the Python code to pseudocode
//     if (line.startsWith('def ')) {
//       // Function definition
//       pseudocode += 'FUNCTION ${line.substring(4)}';
//     } else if (line.startsWith('if ')) {
//       // If statement
//       pseudocode += 'IF ${line.substring(3)} THEN';
//     } else if (line.startsWith('else:')) {
//       // Else statement
//       pseudocode += 'ELSE';
//     } else if (line.startsWith('for ')) {
//       // For loop
//       pseudocode += 'FOR ${line.substring(4)}';
//     } else if (line.startsWith('while ')) {
//       // While loop
//       pseudocode += 'WHILE ${line.substring(6)}';
//     } else if (line.endsWith(':')) {
//       // Indentation
//       pseudocode += '\t${line.substring(0, line.length - 1)}';
//     } else {
//       // Other lines
//       pseudocode += line;
//     }

//     // Add a newline character to the end of the pseudocode
//     pseudocode += '\n';
//   }

//   // Return the generated pseudocode
//   return pseudocode;
// }
