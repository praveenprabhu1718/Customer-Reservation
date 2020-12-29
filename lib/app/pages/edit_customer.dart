import 'package:customer_reservation_app/app/constants.dart';
import 'package:customer_reservation_app/app/model/customer.dart';
import 'package:customer_reservation_app/app/services/firestore_functions.dart';
import 'package:flutter/material.dart';

class EditCustomer extends StatefulWidget {
  final Customer customer;

  const EditCustomer({Key key, this.customer}) : super(key: key);

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  FirestoreFunctions _firestoreFunctions = FirestoreFunctions();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController;
  TextEditingController _phoneNumberController;
  TextEditingController _emailController;

  DateTime _pickedDate;
  TimeOfDay _time;

  String get _name => _nameController.text.trim();
  String get _phoneNumber => _phoneNumberController.text.trim();
  String get _email => _emailController.text.trim();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneNumberController =
        TextEditingController(text: widget.customer.phoneNumber);
    _emailController = TextEditingController(text: widget.customer.emailId);
    _time = stringToTimeOfDay(widget.customer.time);
    _pickedDate = stringToDateTime(widget.customer.date);
  }

  DateTime stringToDateTime(String string) {
    DateTime dateTime = DateTime.parse(string.substring(6) +
        '-' +
        string.substring(3, 5) +
        '-' +
        string.substring(0, 2));
    return dateTime;
  }

  TimeOfDay stringToTimeOfDay(String string) {
    TimeOfDay time = TimeOfDay(
        hour: int.parse(string.substring(0, 2)),
        minute: int.parse(string.substring(3, 5)));
    return time;
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _pickedDate,
    );
    if (date != null)
      setState(() {
        _pickedDate = date;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: _time);
    if (t != null)
      setState(() {
        _time = t;
      });
  }

  _update() {
    if (_name.isEmpty) {
      final _snackBar = SnackBar(content: Text('Name can\'t be empty'));
      _scaffoldKey.currentState.showSnackBar(_snackBar);
    } else if (_phoneNumber.isEmpty) {
      final _snackBar = SnackBar(content: Text('Phone Number can\'t be empty'));
      _scaffoldKey.currentState.showSnackBar(_snackBar);
    } else if (_email.isEmpty) {
      final _snackBar = SnackBar(content: Text('Email can\'t be empty'));
      _scaffoldKey.currentState.showSnackBar(_snackBar);
    } else {
      String date = _pickedDate.day.toString() +
          '-' +
          _pickedDate.month.toString() +
          '-' +
          _pickedDate.year.toString();
      String hour = _time.hour.toString();
      String minute;
      if (_time.minute == 0) {
        minute = _time.minute.toString() + '0';
      } else if (_time.minute < 10) {
        minute = '0' + _time.minute.toString();
      } else {
        minute = _time.minute.toString();
      }
      String time = hour + ':' + minute + ' hrs';
      Customer customer = Customer(
        name: _name,
        phoneNumber: _phoneNumber,
        emailId: _email,
        date: date,
        time: time,
        docId: widget.customer.docId,
      );
      _firestoreFunctions.updateCustomer(customer);
      Navigator.pop(context);
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('Edit Customer'),
      backgroundColor: primaryColor,
    );
  }

  Padding placeHolder(
      {BuildContext context,
      String title,
      TextEditingController controller,
      TextInputType textInputType,
      String value}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              child: TextField(
                controller: controller,
                cursorColor: primaryColor,
                textInputAction: TextInputAction.next,
                keyboardType: textInputType,
                decoration: InputDecoration(
                  border: border,
                  focusedBorder: focusedBorder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _updateButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _update,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: primaryColor,
          ),
          child: Center(
            child: Text(
              'Upload',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile _dateField() {
    return ListTile(
      title: Center(
        child: Text(
            "Date: ${_pickedDate.day}-${_pickedDate.month}-${_pickedDate.year}"),
      ),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: _pickDate,
    );
  }

  ListTile _timeField() {
    return ListTile(
      title: Center(
        child: Text('Time: ${_time.hour}:${_time.minute}'),
      ),
      trailing: Icon(Icons.keyboard_arrow_down),
      onTap: _pickTime,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: placeHolder(
            context: context,
            title: 'Name',
            controller: _nameController,
            textInputType: TextInputType.text,
          ),
        ),
        Flexible(
          child: placeHolder(
            context: context,
            title: 'Phone Number',
            controller: _phoneNumberController,
            textInputType: TextInputType.number,
          ),
        ),
        Flexible(
          child: placeHolder(
            context: context,
            title: 'Email Id',
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
          ),
        ),
        _dateField(),
        SizedBox(height: 8),
        _timeField(),
        SizedBox(height: 8),
        _updateButton(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: _buildContent(context),
    );
  }
}
