import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;
import 'SideMenu.dart';
import 'model/GetContactList.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late Future<GetContactList> fetchdata;
  List<ContactData> shiftoffload = []; // Holds the original data
  List<ContactData> filteredContacts = []; // Holds the filtered data based on search

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String userId = GetStorage().read("id");
    _searchController.addListener(_filterContacts);  // This triggers the filter whenever the search text changes
    fetchdata = ProcedureApiService.fetchRouteData(userId);
  }

  // Function to filter contacts based on the search input
  void _filterContacts() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = shiftoffload.where((contact) {
        String fullName = "${contact.firstName ?? ''} ${contact.lastName ?? ''}".toLowerCase();
        return fullName.contains(searchText);
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Image.asset(
                'assets/images/list.png',
                width: 20,
                height: 20,
              ),
            );
          },
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/shiftlogo.png',
          width: 100,
          height: 60,
        ),
      ),
      body: Container(
        color: const Color(0xFF73CDEF),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search by name",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<GetContactList>(
                future: fetchdata,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.data == null) {
                    return const Center(child: Text("No data available"));
                  } else {
                    // Update data only when it's successfully fetched
                    if (shiftoffload.isEmpty) {
                      shiftoffload = snapshot.data!.data!;
                      filteredContacts = List.from(shiftoffload); // Initialize filtered list
                    }

                    // Display filtered contacts
                    return ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF142247),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: const Color(0xFF142247),
                                width: 4,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextRow("Name", "${contact.firstName ?? ''} ${contact.lastName ?? ''}"),
                                const SizedBox(height: 10),
                                _buildTextRow("Email", contact.email ?? ''),
                                const SizedBox(height: 10),
                                _buildTextRow("Mobile Number", contact.mobileNo ?? ''),
                                const SizedBox(height: 10),
                                const Text(
                                  'Qualifications:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                _buildQualificationButtons(contact.qualifications),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins_normal',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins_normal',
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildQualificationButtons(List<Qualifications>? qualifications) {
    if (qualifications == null || qualifications.isEmpty) {
      return const Text(
        "No qualifications available",
        style: TextStyle(color: Colors.white),
      );
    }

    return Wrap(
      spacing: 8.0, // Horizontal space between items
      runSpacing: 8.0, // Vertical space between rows
      children: qualifications.map((qualification) {
        return ElevatedButton(
          onPressed: () {
            // Handle button press here
            print("Pressed: ${qualification.name}");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF066E95), // Set button background color
            foregroundColor: Colors.white, // Set text color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            qualification.name ?? 'Unknown',
            style: const TextStyle(
              fontFamily: 'Poppins_normal',
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        );
      }).toList(),
    );
  }
}




class ProcedureApiService {
  static var client = http.Client();

  static Future<GetContactList> fetchRouteData(
      String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.get_user_list);
    Map body = {
      'user_id': userid,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}
