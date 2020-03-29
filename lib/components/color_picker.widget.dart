import 'package:flutter/material.dart';
import 'package:dismay_app/resources/constants/colors.consts.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key key,
    this.padding,
    @required this.title,
    @required this.onPick,
    this.basic = false,
    this.current,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final String title;
  final Function(Color) onPick;
  final bool basic;
  final Color current;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = basic ? [Colors.white, Colors.black] : Colors.accents;

    return Padding(
      padding: padding ?? const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: textStyleWhite,
            ),
            Wrap(
              children: colors
                  .map(
                    (Color color) => Padding(
                      padding: padding ?? const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => onPick(color),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(25),
                              border: current == color
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
