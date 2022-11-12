import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocCreation extends StatelessWidget {
  const DocCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text('Add document'),
      onPressed: () {
        CollectionReference users =
            FirebaseFirestore.instance.collection('find_track_app');

        print(users);

        // users
        //     .doc('ABC123')
        //     .set({'full_name': "Mary Jane", 'age': 18})
        //     .then((value) => print("User Added"))
        //     .catchError((error) => print("Failed to add user: $error"));
        users.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            print(doc["favList"]);
          });
        });
      },
    ));
  }
}
