import 'package:callerxyz/modules/home/screens/calendar_view.dart';
import 'package:callerxyz/modules/home/screens/your_records.dart';
import 'package:callerxyz/riverpod/fcm_init.dart';
import 'package:callerxyz/modules/shared/screens/user_info.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // String fcmToken = await FirebaseFcmModel().initFcmToken();
    String fcmToken = await FirebaseFcmManager().getFcmToken();

    final data = await supabase
        .from('users')
        .update({'fcm_token': fcmToken})
        .eq('uid', supabase.auth.currentUser!.id)
        .select("fcm_token");

    debugPrint("FCM Token Updated: $data");
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
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Calendar
            CallendarView(),

            SizedBox(height: 20),
            //Your Record
            Expanded(child: YourRecordSection()),
          ],
        ),
      ),
    );
  }
}
