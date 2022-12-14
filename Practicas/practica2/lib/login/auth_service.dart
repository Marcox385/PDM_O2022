import 'package:findtrackapp_v2/identify/identify_screen.dart';
import 'package:findtrackapp_v2/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            CollectionReference users =
                FirebaseFirestore.instance.collection('find_track_app');

            queryUsers = users
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((QuerySnapshot querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                print(doc);
                var songs = doc['fav_list'];

                if (songs == null) {
                  users.doc(FirebaseAuth.instance.currentUser!.uid).set({
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'fav_list': {}
                  });

                  return;
                }
              });
            });
            return IdentifyScreen();
          } else {
            return const LoginScreen();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
