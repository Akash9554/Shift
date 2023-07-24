import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String surname = '';
  String mobile = '';
  String email = '';
  String state = 'SA';
  String fsShift = 'A';
  String qualifications = '';
  String image = '';
  String bio = '';
  String erp = '';
  String max = '';
  String betweenFSshifts = '';

  List<String> fsShiftList = ['Select FS Shift', 'A', 'B', 'C', 'D', 'NONE'];
  List<String> stateList = ['SA', 'WA'];
  List<int> _numberList = List.generate(201, (index) => index - 100);
  List<int> _numberListsec = List.generate(201, (index) => index - 100);

  PickedFile? _image;

  Future<void> _choosePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Name',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Surname',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    surname = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Mobile',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    mobile = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF142247),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'State',
                          style: TextStyle(
                            color: Color(0xFF142247),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            value: state,
                            items: stateList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF142247),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                state = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFF142247),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FS Shift',
                          style: TextStyle(
                            color: Color(0xFF142247),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            value: fsShift,
                            items: fsShiftList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                    color: Color(0xFF142247),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                fsShift = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Qualification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 120,
                /*child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: qualifications.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          qualifications[index]['name'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),*/
              ),
              SizedBox(height: 20),
              Text(
                'Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    _image == null
                        ? Text('No image selected')
                        : Image.file(File(_image!.path)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _choosePhoto,
                      child: Text('Choose Photo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
