import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Firebaseauthoptions {
  // GOOGLE SIGN IN
  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        //   // Create a new credential
        //   final credential = GoogleAuthProvider.credential(
        //     accessToken: googleAuth?.accessToken,
        //     idToken: googleAuth?.idToken,
        //   );
        //   UserCredential userCredential =
        //       await FirebaseAuth.instance.signInWithCredential(credential);

        //   // if you want to do specific task like storing information in firestore
        //   // only for new users using google sign in (since there are no two options
        //   // for google sign in and google sign up, only one as of now),
        //   // do the following:

        //   // if (userCredential.user != null) {
        //   //   if (userCredential.additionalUserInfo!.isNewUser) {}
        //   // }

        // }
      }
    } on FirebaseAuthException {
      // showSnackBar(context, e.message!); // Displaying the error message
    }
  }
}
