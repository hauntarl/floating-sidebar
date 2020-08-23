import 'dart:math' as math show pi;

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import './collapsible_sidebar/collapsible_sidebar.dart';
import './collapsible_sidebar/collapsible_item.dart';

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
  List<CollapsibleItem> _items;
  String _headline;

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _headline = _items.firstWhere((item) => item.isSelected).title;
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        title: 'Dashboard',
        icon: Icons.assessment,
        onPressed: () => setState(() => _headline = 'DashBoard'),
      ),
      CollapsibleItem(
        title: 'Errors',
        icon: Icons.cancel,
        onPressed: () => setState(() => _headline = 'Errors'),
        isSelected: true,
      ),
      CollapsibleItem(
        title: 'Search',
        icon: Icons.search,
        onPressed: () => setState(() => _headline = 'Search'),
      ),
      CollapsibleItem(
        title: 'Notifications',
        icon: Icons.notifications,
        onPressed: () => setState(() => _headline = 'Notifications'),
      ),
      CollapsibleItem(
        title: 'Settings',
        icon: Icons.settings,
        onPressed: () => setState(() => _headline = 'Settings'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        _body(size, context),
        Padding(
          padding: EdgeInsets.all(4),
          child: _createSidebar(context, size.width),
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
              _headline,
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createSidebar(BuildContext context, double width) {
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
