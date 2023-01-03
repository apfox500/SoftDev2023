import 'package:flutter/material.dart';

import '../../models/global.dart';
import '../../widgets/footer_buttons.dart';

class IDEPage extends StatefulWidget {
  const IDEPage(this.global, {super.key});
  final Global global;

  @override
  State<IDEPage> createState() => _IDEPageState();
}

class _IDEPageState extends State<IDEPage> {
  @override
  Widget build(BuildContext context) {
    Global global = widget.global;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Global.davysGrey,
      body: const SafeArea(
        child: Center(),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "IDE",
      ),
    );
  }
}
