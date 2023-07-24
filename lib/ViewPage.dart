import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class MyPage extends StatelessWidget {
  final String data;
  final String subject;
  final int offload;
  final String id;

  MyPage({required this.data, required this.subject, required this.offload, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF142247)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Image.asset(
          'assets/images/shiftlogo.png',
          width: 100,
          height: 60,
        ),
      ),
      body: Container(
        color: Color(0xFF73CDEF),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject,
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'Poppins_normal',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            if (offload == 1)
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF066E95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'You want to grab this shift',
                  style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(height: 20),
            HtmlWidget(data),
          ],
        ),
      ),
    );
  }
}
