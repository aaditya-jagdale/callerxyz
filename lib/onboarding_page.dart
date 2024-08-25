import 'package:callerxyz/modules/home/screens/home_screen.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  //vars
  final supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passowordController = TextEditingController();
  bool _loading = false;
  String? _emailErrorText;
  String? _passwordErrorText;

  //Google signing
  Future signUp() async {
    supabase.auth
        .signUp(
      email: _emailController.text.trim(),
      password: _passowordController.text.trim(),
    )
        .then((response) {
      if (response.user == null) return;
      // final Session? session = response.session;
      final User? user = response.user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(checkUser: true),
        ),
      );
    }).onError((AuthException error, stackTrace) {
      if (error.code == "email_exists") {
        signIn();
      } else if (error.code == "over_email_send_rate_limit") {
        errorSnackBar(context,
            "We are experiencing a high volume of requests. Please try again later.");
      }
      throw error;
    });

    setState(() {
      _loading = false;
    });
  }

  Future signIn() async {
    supabase.auth
        .signInWithPassword(
      email: _emailController.text.trim(),
      password: _passowordController.text.trim(),
    )
        .then((res) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }).onError((AuthException? error, stacktrace) {
      if (error!.message == "Invalid login credentials") {
        errorSnackBar(context, "Invalid login credentials");
      } else {}
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'caller',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.black50,
                              fontSize: 48,
                            ),
                          ),
                          TextSpan(
                            text: 'XYZ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'A minimal cold calls\nprogress tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.2,
                        color: CustomColors.black50,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 50),
                    if (_loading) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            if (!_loading)
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      setState(() {
                        _emailErrorText = null;
                      });
                    },
                    decoration: InputDecoration(
                      errorText: _emailErrorText,
                      hintText: 'example@gmail.com',
                      hintStyle: const TextStyle(
                        color: CustomColors.black50,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: CustomColors.black10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: CustomColors.red,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passowordController,
                    onChanged: (value) {
                      setState(() {
                        _passwordErrorText = null;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: _passwordErrorText,
                      hintText: 'Minimum 6 characters',
                      hintStyle: const TextStyle(
                        color: CustomColors.black50,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: CustomColors.black10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: CustomColors.red,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomPrimaryButton(
                    title: "Sign Up",
                    onTap: () {
                      if (!(_emailController.text.trim().contains("@") &&
                          _emailController.text.trim().contains("."))) {
                        setState(() {
                          _emailErrorText = 'Email is invalid';
                        });
                      }
                      if (_emailController.text.trim().isEmpty) {
                        setState(() {
                          _emailErrorText = 'Email is required';
                        });
                      } else if (_passowordController.text.trim().isEmpty) {
                        setState(() {
                          _passwordErrorText = 'Password is required';
                        });
                      } else {
                        setState(() {
                          _loading = true;
                        });
                        signIn();
                      }
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
