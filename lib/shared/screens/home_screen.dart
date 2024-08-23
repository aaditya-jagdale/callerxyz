import 'package:callerxyz/riverpod/fcm_init.dart';
import 'package:callerxyz/shared/screens/user_info.dart';
import 'package:callerxyz/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool checkUser;
  const HomeScreen({super.key, this.checkUser = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final supabase = Supabase.instance.client;

  updateFcmToken() async {
    String fcmToken = await FirebaseFcmManager().initFcmToken();

    final data = await supabase
        .from('users')
        .update({'fcm_token': fcmToken})
        .eq('uid', supabase.auth.currentUser!.id)
        .select("fcm_token");

    debugPrint("FCM Token Updated: ${data}");
  }

  checkUser() async {
    supabase
        .from('users')
        .select("email")
        .then((List<Map<String, dynamic>>? userList) {
      bool existingUser = userList!
          .map((e) => e["email"].toString().toLowerCase())
          .toList()
          .contains(supabase.auth.currentUser!.email!.toLowerCase());

      if (!existingUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserInfoPage(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //ensure init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.checkUser) checkUser();
      updateFcmToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: [
              TextSpan(
                text: 'caller',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.black50,
                ),
              ),
              TextSpan(
                text: 'XYZ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            //Calendar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CustomColors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: CustomColors.black25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SvgPicture.asset("assets/phone_outgoing.svg"),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Streak",
                        style: TextStyle(
                          color: CustomColors.black25,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        40,
                        (index) => Column(
                          children: List.generate(
                            7,
                            (index) => Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: CustomColors.black25,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              margin: const EdgeInsets.all(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            //Your Record
            const Text(
              "Your Record",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
