import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/modules/shared/widgets/textfields.dart';
import 'package:callerxyz/onboarding_page.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _resettingPassword = false;
  final supabase = Supabase.instance.client;

  getUserData() {
    supabase
        .from('users')
        .select("name, email, location")
        .eq('uid', supabase.auth.currentUser!.id)
        .then((data) {
      if (data.isNotEmpty) {
        _nameController.text = data[0]['name'] ?? '';
        _emailController.text = data[0]['email'] ?? '';
      }
    });
  }

  Future<void> _sendPasswordRecoveryEmail() async {
    setState(() {
      _resettingPassword = true;
    });

    await supabase.auth
        .resetPasswordForEmail(_emailController.text.trim())
        .then((value) {
      setState(() {
        _resettingPassword = false;
      });
      successSnackBar(context, 'Link has been sent to your email');
    }).onError((error, stackTrace) {
      setState(() {
        _resettingPassword = false;
      });
      errorSnackBar(context, error.toString());
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: const Text(
          "Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomTextField(title: 'Name', controller: _nameController),
            CustomTextField(
              title: 'Email',
              controller: _emailController,
              isEnabled: false,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: DottedLine(
                dashColor: CustomColors.black50,
                dashGapLength: 4,
                dashLength: 4,
                lineThickness: 1,
                dashRadius: 0,
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: CustomColors.black10,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined),
                    SizedBox(width: 8),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: CustomColors.black10,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  _sendPasswordRecoveryEmail();
                },
                child: Row(
                  children: [
                    if (_resettingPassword)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: CustomColors.black,
                          strokeWidth: 2,
                        ),
                      ),
                    if (!_resettingPassword) const Icon(Icons.lock_outline),
                    const SizedBox(width: 8),
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: CustomColors.red20,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () {
                  GoogleSignIn().signOut();
                  supabase.auth.signOut().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingPage()),
                    );
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: CustomColors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: CustomColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
