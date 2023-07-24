import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'SideMenu.dart';
class MySideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: Container(
        child: DashboardScreen(),
      ),
    );
  }
}

