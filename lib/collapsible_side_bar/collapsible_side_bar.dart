import 'dart:math' as math show pi;

import 'package:flutter/material.dart';

import './item.dart';
import './item_widget.dart';
import './avatar.dart';

class CollapsibleSideBar extends StatefulWidget {
  const CollapsibleSideBar({
    @required this.items,
    this.name = 'Lorem Ipsum',
    this.avatarUrl,
    this.height = double.infinity,
    this.minWidth = 80,
    this.maxWidth = 275,
    this.borderRadius = 15,
    this.iconSize = 40,
    this.textSize = 20,
    this.padding = 10,
    this.toggleBarIcon = Icons.more_vert,
    this.dropdownIcon = Icons.arrow_drop_down,
    this.backgroundColor = const Color(0xff2B3138),
    this.selectedItemColor = const Color(0xff2F4047),
    this.selectedIconColor = const Color(0xff4AC6EA),
    this.selectedTextColor = const Color(0xffF3F7F7),
    this.unselectedIconColor = const Color(0xff6A7886),
    this.unselectedTextColor = const Color(0xffC0C7D0),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastLinearToSlowEaseIn,
  });

  final String avatarUrl, name;
  final List<Item> items;
  final double height,
      minWidth,
      maxWidth,
      borderRadius,
      iconSize,
      textSize,
      padding;
  final IconData toggleBarIcon, dropdownIcon;
  final Color backgroundColor,
      selectedItemColor,
      selectedIconColor,
      selectedTextColor,
      unselectedIconColor,
      unselectedTextColor;
  final Duration duration;
  final Curve curve;

  @override
  _CollapsibleSideBarState createState() => _CollapsibleSideBarState();
}

class _CollapsibleSideBarState extends State<CollapsibleSideBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _widthAnimation;
  CurvedAnimation _curve;

  var _isCollapsed = true;
  double _currWidth, _delta, _delta1By4, _delta3by4, _maxOffset;
  int _selectedItemIndex;

  @override
  void initState() {
    super.initState();
    _currWidth = widget.minWidth;
    _delta = widget.maxWidth - widget.minWidth;
    _delta1By4 = _delta * 0.25;
    _delta3by4 = _delta * 0.75;
    _maxOffset = widget.padding * 2 + widget.iconSize;
    for (var i = 0; i < widget.items.length; i++)
      if (widget.items[i].isSelected) {
        _selectedItemIndex = i;
        break;
      }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _curve = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _widthAnimation = Tween<double>(
      begin: widget.minWidth,
      end: widget.maxWidth,
    ).animate(_curve);

    _controller.addListener(() {
      _currWidth = _widthAnimation.value;
      if (_controller.isCompleted)
        _isCollapsed = _currWidth == widget.minWidth ? true : false;
      setState(() {});
    });
  }

  void _animateTo(double endWidth) {
    _widthAnimation = Tween<double>(
      begin: _currWidth,
      end: endWidth,
    ).animate(_curve);
    _controller.reset();
    _controller.forward();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _currWidth += details.primaryDelta;
    if (_currWidth > widget.maxWidth)
      _currWidth = widget.maxWidth;
    else if (_currWidth < widget.minWidth) _currWidth = widget.minWidth;
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_currWidth == widget.maxWidth) {
      setState(() => _isCollapsed = false);
      return;
    } else if (_currWidth == widget.minWidth) {
      setState(() => _isCollapsed = true);
      return;
    }
    var threshold = _isCollapsed ? _delta1By4 : _delta3by4;
    var endWidth = _currWidth - widget.minWidth > threshold
        ? widget.maxWidth
        : widget.minWidth;
    _animateTo(endWidth);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Container(
        height: widget.height,
        width: _currWidth,
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: widget.backgroundColor,
              blurRadius: 10,
              spreadRadius: 0.01,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar,
            Spacer(),
            ..._items,
            SizedBox(height: 50),
            Divider(
              color: widget.unselectedIconColor,
              indent: 5,
              endIndent: 5,
            ),
            _toggleButton,
          ],
        ),
      ),
    );
  }

  Widget get _avatar {
    return ItemWidget(
      leading: Avatar(
        backgroundColor: widget.unselectedIconColor,
        iconSize: widget.iconSize,
        name: widget.name,
        avatarUrl: widget.avatarUrl,
        textStyle: _textStyle(widget.backgroundColor),
      ),
      title: widget.name,
      textStyle: _textStyle(widget.unselectedTextColor),
      offsetX: _offsetX,
      scale: _fraction,
    );
  }

  List<Widget> get _items {
    return List.generate(widget.items.length, (index) {
      var item = widget.items[index];
      var bgColor = Colors.transparent;
      var iconColor = widget.unselectedIconColor;
      var textColor = widget.unselectedTextColor;
      if (item.isSelected) {
        bgColor = widget.selectedItemColor;
        iconColor = widget.selectedIconColor;
        textColor = widget.selectedTextColor;
      }
      return GestureDetector(
        onTap: () {
          if (_selectedItemIndex == index) return;
          item.onPressed();
          widget.items[_selectedItemIndex].isSelected = false;
          widget.items[index].isSelected = true;
          setState(() => _selectedItemIndex = index);
        },
        child: ItemWidget(
          backgroundColor: bgColor,
          leading: Icon(
            item.icon,
            size: widget.iconSize,
            color: iconColor,
          ),
          title: item.title,
          textStyle: _textStyle(textColor),
          offsetX: _offsetX,
          scale: _fraction,
        ),
      );
    });
  }

  void _toggleBar() {
    _isCollapsed = !_isCollapsed;
    var endWidth = _isCollapsed ? widget.minWidth : widget.maxWidth;
    _animateTo(endWidth);
  }

  Widget get _toggleButton {
    return GestureDetector(
      onTap: _toggleBar,
      child: ItemWidget(
        leading: Transform.rotate(
          angle: _currAngle,
          child: Icon(
            Icons.arrow_forward_ios,
            size: widget.iconSize,
            color: widget.unselectedIconColor,
          ),
        ),
        title: 'Collapse',
        textStyle: _textStyle(widget.unselectedTextColor),
        offsetX: _offsetX,
        scale: _fraction,
      ),
    );
  }

  double get _fraction => (_currWidth - widget.minWidth) / _delta;

  double get _currAngle => -math.pi * _fraction;

  double get _offsetX => _maxOffset * _fraction;

  TextStyle _textStyle(Color color) {
    return TextStyle(
      fontSize: widget.textSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
