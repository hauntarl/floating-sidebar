import 'dart:math' as math show pi;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import './collapsible_side_bar/item.dart';
import './collapsible_side_bar/collapsible_side_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidebar ui',
      home: Scaffold(
        body: SidebarPage(),
      ),
    );
  }
}

class SidebarPage extends StatefulWidget {
  @override
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  List<Item> _items;
  String pageTitle;

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    for (var item in _items)
      if (item.isSelected) {
        pageTitle = item.title;
        break;
      }
  }

  List<Item> get _generateItems {
    return [
      Item(
        title: 'Dashboard',
        icon: Icons.assessment,
        onPressed: () => setState(() => pageTitle = 'DashBoard'),
      ),
      Item(
        title: 'Errors',
        icon: Icons.cancel,
        onPressed: () => setState(() => pageTitle = 'Errors'),
        isSelected: true,
      ),
      Item(
        title: 'Search',
        icon: Icons.search,
        onPressed: () => setState(() => pageTitle = 'Search'),
      ),
      Item(
        title: 'Notifications',
        icon: Icons.notifications,
        onPressed: () => setState(() => pageTitle = 'Notifications'),
      ),
      Item(
        title: 'Settings',
        icon: Icons.settings,
        onPressed: () => setState(() => pageTitle = 'Settings'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        _body(size, context),
        Padding(
          padding: EdgeInsets.all(4),
          child: _sideBar(context, size.width),
        ),
      ],
    );
  }

  Widget _body(Size size, BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: Center(
        child: Transform.rotate(
          angle: math.pi / 2,
          child: Transform.translate(
            offset: Offset(-size.height * 0.2, -size.width * 0.3),
            child: Text(
              pageTitle,
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sideBar(BuildContext context, double width) {
    return CollapsibleSideBar(
      maxWidth: width * 0.75,
      items: _items,
      avatarUrl: _avatarUrl,
      name: 'Sameer Mungole',
    );
  }
}

const _avatarUrl =
    'https://raw.githubusercontent.com/hauntarl/flutter_samples/master/assets/bleach.png';
