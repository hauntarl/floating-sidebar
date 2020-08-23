import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Item {
  Item({
    @required this.title,
    @required this.icon,
    @required this.onPressed,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  final Function onPressed;
  bool isSelected;
}
