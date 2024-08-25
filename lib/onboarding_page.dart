import 'package:callerxyz/modules/home/screens/home_screen.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  //vars
  final supabase = Supabase.instance.client;
  bool _loading = false;

  googleSignin() async {
    String webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
    String iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID']!;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth
        .signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    )
        .then((value) async {
      setState(() {
        _loading = false;
      });

      await supabase.from('users').insert({
        'uid': supabase.auth.currentUser!.id,
        'email': googleUser.email,
        'name': googleUser.displayName,
        'photo_url': googleUser.photoUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).then(
        (value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
      );
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
                  CustomPrimaryButton(
                    btnIcon: SvgPicture.asset(
                      'assets/google.svg',
                      width: 20,
                      height: 20,
                    ),
                    title: "Start tracking",
                    onTap: () async {
                      setState(() {
                        _loading = true;
                      });
                      googleSignin();
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
