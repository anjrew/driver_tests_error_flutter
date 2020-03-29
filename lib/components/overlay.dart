import 'package:flutter/material.dart';

class DarkOverlay extends StatelessWidget {
    final bool show;
    const DarkOverlay({@required this.show});

    @override
    Widget build(BuildContext context) {
        return AnimatedOpacity(
			key: const Key("overlay"),
			duration: const Duration(seconds: 1),
            opacity: show ? 1 : 0,
            child: IgnorePointer(
                ignoring: !show,
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black,
                    child: const Center(
                        child: CircularProgressIndicator(),
                    ),
                ),
            ),
        );
    }
}
