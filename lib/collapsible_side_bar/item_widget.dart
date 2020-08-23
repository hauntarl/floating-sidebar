import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    @required this.leading,
    @required this.title,
    @required this.textStyle,
    this.backgroundColor = Colors.transparent,
    this.offsetX = 0,
    this.scale = 0,
  });

  final Widget leading;
  final String title;
  final TextStyle textStyle;
  final Color backgroundColor;
  final double offsetX, scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          leading,
          _title,
        ],
      ),
    );
  }

  Widget get _title {
    return Opacity(
      opacity: scale,
      child: Transform.translate(
        offset: Offset(offsetX, 0),
        child: Transform.scale(
          scale: scale,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: textStyle,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
  }
}
