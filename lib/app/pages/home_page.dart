import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_reservation_app/app/model/customer.dart';
import 'package:customer_reservation_app/app/pages/customer_registration_page.dart';
import 'package:customer_reservation_app/app/pages/edit_customer.dart';
import 'package:customer_reservation_app/app/services/auth.dart';
import 'package:customer_reservation_app/app/services/firestore_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  final AuthBase auth;

  HomePage({@required this.auth});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirestoreFunctions _firestoreFunctions = FirestoreFunctions();

  _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            height: 125,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Do you want to logout?',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 75,
                              height: 25,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'No',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _signOut();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 75,
                              height: 25,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteCustomer(Customer customer) async {
    await _firestoreFunctions.deleteCustomer(customer);
    final snackBar = SnackBar(
      content: Text('${customer.name} has deleted'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _navigateToCustomerRegistrationScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => CustomerRegistrationPage(),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: primaryColor,
      elevation: 8,
      onPressed: () => _navigateToCustomerRegistrationScreen(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text('Customer Reservations'),
      centerTitle: true,
      backgroundColor: primaryColor,
      actions: [
        FlatButton(
          onPressed: () => _showLogoutDialog(context),
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Padding textHolder(String title, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context, Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomer(
          customer: customer,
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> _buildStreamBuilder() {
    return StreamBuilder(
      stream: _firestoreFunctions.getSnapshot(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: primaryColor,
            ),
          );
        }

        var docList = snapshot.data.docs;
        if (docList.isEmpty) {
          return Center(
            child: Text(
                'No customer reservations. Click add button to add customers.'),
          );
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: snapshot.data.docs.map((doc) {
            Customer customer = Customer.fromMap(doc);
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Container(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/customer.png',
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textHolder('Name: ', customer.name),
                            textHolder('Email: ', customer.emailId),
                            textHolder('Phone Number: ', customer.phoneNumber),
                            textHolder('Date: ', customer.date),
                            textHolder('Time: ', customer.time),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () => _edit(context, customer),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.edit,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      _deleteCustomer(customer);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildStreamBuilder(),
      floatingActionButton: _buildFloatingActionButton(context),
      appBar: _appBar(context),
    );
  }
}
