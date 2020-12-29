
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_reservation_app/app/model/customer.dart';

class FirestoreFunctions {
  CollectionReference _customer =
      FirebaseFirestore.instance.collection('Customer');

  Future<void> addCustomer(Customer customer) async {
    await _customer
        .add(customer.toJson())
        .then((value) => print('Customer Added'))
        .catchError((e) => print('Failed to add'));
  }

  Future<void> updateCustomer(Customer customer) async {
    await _customer
        .doc(customer.docId)
        .update(customer.toJson())
        .then((value) => print('Customer Details updated'))
        .catchError((e) => print(e.toString()));
  }

  Future<void> deleteCustomer(Customer customer) async {
    await _customer
        .doc(customer.docId)
        .delete()
        .then((value) => print('Customer deleted'))
        .catchError((e) => print(e.toString()));
  }

  Stream<QuerySnapshot> getSnapshot() {
    return _customer.snapshots();
  }
}
