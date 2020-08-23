import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    @required this.iconSize,
    @required this.backgroundColor,
    @required this.name,
    @required this.avatarUrl,
    @required this.textStyle,
  });

  final double iconSize;
  final Color backgroundColor;
  final String avatarUrl, name;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize,
      width: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(iconSize),
        color: backgroundColor,
      ),
      child: avatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(iconSize),
              child: Image.network(
                avatarUrl,
                fit: BoxFit.fill,
                height: iconSize,
                width: iconSize,
              ),
            )
          : Center(
              child: Text(
                '${name.substring(0, 1).toUpperCase()}',
                style: textStyle,
              ),
            ),
    );
  }
}
