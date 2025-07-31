import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Availability.dart';
import 'Availabilitynew.dart';
import 'SideMenu.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}
class _MyAppState extends State<MyApp> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: MonthCalendars(),
        drawer: SideMenu(),
                        ),
    );
  }
}


