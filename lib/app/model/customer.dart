import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String name;
  final String phoneNumber;
  final String emailId;
  final String date;
  final String time;
  final String docId;

  Customer(
      {this.name,
      this.phoneNumber,
      this.emailId,
      this.date,
      this.time,
      this.docId});

  Customer.fromMap(QueryDocumentSnapshot snapshot)
      : name = snapshot['name'],
        phoneNumber = snapshot['phoneNumber'],
        emailId = snapshot['emailId'],
        date = snapshot['date'],
        docId = snapshot.id,
        time = snapshot['time'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'date': date,
        'time': time
      };
}
