/**
 * The following libraries are widgets made for UX
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/**
 * The following package is what allows access to any machines camer system
 */
import 'package:image_picker/image_picker.dart';

//Dart package for data conversion
import 'dart:convert';

/**
 * Pre-built modules made for this Stateful widget
 */
import '../../widgets/footer_buttons.dart';
import '../../models/global.dart';

/**
 * This imported module is what makes the HTTPS request 
 * and sends the image in a base64 to the python script
 */
import '../../providers/get_data_from_python_script.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  /// Declared state variables made to update to the values returned
  /// by the recognition script
  late String Libraries = "";
  late String VariablesDec = "";
  late String UnrecognizedData = "";
  List<dynamic> libs = [''];
  List<Map<String, String>> libsWithDescription = [];

  ///State boolean variables on whether or not to make widgets visible
  bool libsWithDescriptionBool = false;
  bool show = false;
  bool loadingState = false;
  bool hasLibraries = false;

  @override
  Widget build(BuildContext context) {
    Global global = widget.global;

    ///Initialize the camera system variable using the ImagePicker package
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

                    ///Method invoked when the "Take Photo" buton is clicked
                    onPressed: () async {
                      ///Loading state turned on
                      EasyLoading.show(status: 'loading...');

                      ///Reset all the state variables when new phtos are taken or when the page first refreshes
                      setState(() {
                        Libraries = "";
                        VariablesDec = "";
                        UnrecognizedData = "";
                        hasLibraries = false;
                        show = false;
                      });

                      ///Take the actual photo and returns a future.
                      ///Await keyword used to invoke a Promise method
                      ///Uses the machine's source camera, as opposed to it's gallery
                      ///Returned as an XFile which is a sub-class of File
                      XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);

                      /**
                       * Basically need to send the image to GCP
                       * GCP will run Chiranth's python script
                       * GCP will return a text file/JSON object for interpretation
                       */

                      ///The taken photo is converted to a bytecode-esque format
                      ///This is returned as a list of integers
                      List<int> imageBytes =
                          await photo?.readAsBytes() as List<int>;

                      ///Encode the bytecode into base64 for images
                      ///Uses base64 and sends HTTPS body with such string k
                      String img64 = base64Encode(imageBytes);

                      //send base64 string to method that makes API call to GCP Python Script
                      final result = await getDataFromImageAnalyzer(img64);

                      ///This check is if the recgonition detects imported libraries.
                      ///This will then make a Firestore call and get descriptions of the libraries imported
                      if (result.Libs.isNotEmpty) {
                        final libraryDesc =
                            await getPythonLibraryDescription(result.Libs);
                        if (libraryDesc.isNotEmpty) {
                          libsWithDescription = libraryDesc;
                          libsWithDescriptionBool = true;
                        }
                      }

                      ///Set the state variables to be the updated descriptions
                      setState(() {
                        Libraries = result.libraries;
                        VariablesDec = result.VariablesDeclared;
                        UnrecognizedData = result.UnrecognizedData;
                        if (result.Libs.isNotEmpty) {
                          hasLibraries = true;
                          libs = result.Libs;
                        }
                        show = true;
                      });

                      ///Turn off loading screen
                      EasyLoading.dismiss();
                    },
                    child: const Text("Take Photo")),
                ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading...');
                      setState(() {
                        Libraries = "";
                        VariablesDec = "";
                        UnrecognizedData = "";
                        hasLibraries = false;
                        show = false;
                      });

                      XFile? photo =
                          await picker.pickImage(source: ImageSource.gallery);

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
                      if (result.Libs.isNotEmpty) {
                        final libraryDesc =
                            await getPythonLibraryDescription(result.Libs);
                        if (libraryDesc.isNotEmpty) {
                          libsWithDescription = libraryDesc;
                          libsWithDescriptionBool = true;
                        }
                      }
                      setState(() {
                        Libraries = result.libraries;
                        VariablesDec = result.VariablesDeclared;
                        UnrecognizedData = result.UnrecognizedData;
                        if (result.Libs.isNotEmpty) {
                          hasLibraries = true;
                          libs = result.Libs;
                        }
                        show = true;
                      });

                      EasyLoading.dismiss();

                      // copy the file to a new path
                      //final XFile newImage = await photo?.copy('$path/image1.png');
                    },
                    child: const Text("Choose Image from Library")),
                Visibility(
                    visible: show,
                    child: Column(
                      children: [
                        Visibility(
                          visible: hasLibraries,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 239, 190, 111),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              Libraries,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Visibility(
                            visible: libsWithDescriptionBool,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: libsWithDescription.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 246, 211, 155),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child:
                                      Text.rich(TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: libsWithDescription[i]['Lib'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text:
                                            ': ${libsWithDescription[i]['Description']}'),
                                  ])),
                                );
                              },
                            )),
                        Visibility(
                            visible: !hasLibraries,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 246, 211, 155),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: const Text(
                                    "No libraries have been imported"))),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 15, bottom: 5),
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
