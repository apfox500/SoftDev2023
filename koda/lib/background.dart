import 'package:flutter/material.dart';

BoxDecoration backgroundDecoration(BuildContext context) {
  //TODO: background and navigation horizontal if on macos
  //TODO: pick another background if we don't like this one
  return BoxDecoration(
    color: (Theme.of(context).brightness == Brightness.light) ? Theme.of(context).primaryColor : null,
    image: (Theme.of(context).brightness == Brightness.light)
        ? DecorationImage(
            fit: BoxFit.contain,
            opacity: .35,
            colorFilter: ColorFilter.mode(Theme.of(context).primaryColor,
                BlendMode.overlay), //big uggo fr like absolute shit pls change
            image: const AssetImage('assets/background.jpg'),
            repeat: ImageRepeat.repeat,
            matchTextDirection: true,
          )
        : DecorationImage(
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: const AssetImage('assets/background.jpg'),
            matchTextDirection: true,
          ),
  );
}
