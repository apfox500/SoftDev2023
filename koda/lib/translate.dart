import 'package:flutter/material.dart';

import 'bottom_buttons.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const [Text("translate")],
        ),
      ),
      bottomNavigationBar: const FooterButtons(
        page: "translate",
      ),
    );
  }
}
