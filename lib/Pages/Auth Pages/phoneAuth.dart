import 'package:clinicapp/Pages/my_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  bool _isVerifying = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyPhoneNumber,
              child: const Text('Verify'),
            ),
            const SizedBox(height: 16.0),
            Visibility(
              visible: _verificationId != null,
              child: Column(
                children: [
                  TextField(
                    controller: _smsCodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter SMS code',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isVerifying ? null : _signInWithCredential,
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _isVerifying ? 'Verifying...' : '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval of SMS code for Android
          print('SMS code automatically retrieved');
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() {
            _isVerifying = false;
          });
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          setState(() {
            _isVerifying = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Prompt user to enter SMS code
          setState(() {
            _verificationId = verificationId;
            _isVerifying = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
          setState(() {
            _isVerifying = false;
          });
        },
      );
    } catch (e) {
      print('Error verifying phone number: $e');
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _signInWithCredential() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isVerifying = false;
      });
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(),
        ),
      );
    } catch (e) {
      print('Error signing in with credential: $e');
      setState(() {
        _isVerifying = false;
      });
    }
  }
}
