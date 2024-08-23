import 'package:callerxyz/riverpod/fcm_init.dart';
import 'package:callerxyz/modules/home/screens/home_screen.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:callerxyz/modules/shared/widgets/snackbars.dart';
import 'package:callerxyz/modules/shared/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserInfoPage extends ConsumerStatefulWidget {
  const UserInfoPage({super.key});

  @override
  ConsumerState<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends ConsumerState<UserInfoPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  bool _loading = false;
  final supbase = Supabase.instance.client;

  capitalizeFirstLetter(String str) {
    return str[0].toUpperCase() + str.substring(1);
  }

  void uploadUserData() async {
    setState(() {
      _loading = true;
    });
    FocusManager.instance.primaryFocus!.unfocus();
    //upload user data to the database
    String fcmToken = await FirebaseFcmManager().getFcmToken();
    supbase.from('users').insert({
      "name": capitalizeFirstLetter(_nameController.text.trim()),
      "email": _emailController.text.trim().toLowerCase(),
      "location": capitalizeFirstLetter(_countryController.text.trim()),
      "fcm_token": fcmToken,
    }).then((value) {
      setState(() {
        _loading = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }).onError((error, stackTrace) {
      debugPrint("Error: $error");
      errorSnackBar(context, "An error occurred. Please try again later");
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    _emailController.text = supbase.auth.currentUser!.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    title: "Name",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    title: "Email",
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _countryController,
                    title: "Country",
                  ),
                ],
              ),
            ),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (!_loading)
              CustomPrimaryButton(
                title: "Complete",
                onTap: () {
                  if (_nameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _countryController.text.isNotEmpty) {
                    uploadUserData();
                  } else {
                    errorSnackBar(context, "Please fill all fields");
                  }
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
