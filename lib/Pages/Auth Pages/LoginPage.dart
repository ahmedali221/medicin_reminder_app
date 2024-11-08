import 'package:clinicapp/Services/firebaseAuthOptions.dart';
import 'package:clinicapp/Pages/Auth%20Pages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'phoneAuth.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/signInIcon.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

// Email & Password SignIn
  Future<void> loginUserWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // print(userCredential);
        // Navigator.of(context).pushReplacement(
        //   CupertinoPageRoute(
        //     builder: (context) => const MyHomePage(),
        //   ),
        // );
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomInputField(
                lableText: 'Enter Your Email',
                keyboardType: TextInputType.emailAddress,
                Controller: emailController,
                hintText: 'Enter Your Email',
              ),
              const SizedBox(height: 15),
              CustomInputField(
                lableText: 'Enter Your Password',
                keyboardType: TextInputType.visiblePassword,
                Controller: passwordController,
                hintText: 'Enter Your Password',
                obsecure: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 81, 114, 221)),
                onPressed: () async {
                  await loginUserWithEmailAndPassword();
                },
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey, // Customize the line color
                    ),
                  ),
                  const SizedBox(width: 10), // Adjust the spacing as needed
                  const Text(
                    'Or Sign up with',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700), // Customize the text style
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.grey, // Customize the line color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OverflowBar(
                spacing: 35,
                children: [
                  // SignInButtonIcon(
                  //   type: "facebook",
                  //   ontap: () {},
                  // ),
                  SignInButtonIcon(
                    type: "google",
                    ontap: Firebaseauthoptions().signInWithGoogle,
                  ),
                  SignInButtonIcon(
                    type: "phone",
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PhoneAuthScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
