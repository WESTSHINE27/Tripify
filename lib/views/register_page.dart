import 'package:flutter/material.dart';
import 'package:tripify/components/components.dart';
import 'package:tripify/constants.dart';
import 'package:tripify/views/welcome_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  static String id = 'registration_screen';

  @override
  State<RegistrationPage> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationPage> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  late String _confirmPassword;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, WelcomePage.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popAndPushNamed(context, WelcomePage.id);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0, // Removes shadow under the AppBar
        ),
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Register'),
                        const SizedBox(height: 10),
                        CustomTextField(
                          textField: TextField(
                            onChanged: (value) {
                              _email = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Email'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Password'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              _confirmPassword = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Confirm Password'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomBottomScreen(
                          textButton: 'Sign Up',
                          heroTag: 'register_btn',
                          question: 'Have an account?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });

                            if (_password == _confirmPassword) {
                              try {
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);

                                if (context.mounted) {
                                  setState(() {
                                    _saving = false;
                                    Navigator.popAndPushNamed(
                                        context, RegistrationPage.id);
                                  });
                                  // Navigate to home page or another screen
                                }
                              } catch (e) {
                                signUpAlert(
                                  context: context,
                                  onPressed: () {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.popAndPushNamed(
                                        context, RegistrationPage.id);
                                  },
                                  title: 'ERROR',
                                  desc: 'Failed to register. Please try again.',
                                  btnText: 'Try Again',
                                ).show();
                              }
                            } else {
                              showAlert(
                                  context: context,
                                  title: 'PASSWORD MISMATCH',
                                  desc: 'Ensure both passwords match.',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }).show();
                            }
                          },
                          questionPressed: () {
                            Navigator.popAndPushNamed(context, RegistrationPage.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}