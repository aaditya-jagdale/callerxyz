import 'package:callerxyz/modules/home/screens/calendar_view.dart';
import 'package:callerxyz/modules/home/screens/profile_page.dart';
import 'package:callerxyz/modules/home/screens/your_records.dart';
import 'package:callerxyz/riverpod/fcm_init.dart';
import 'package:callerxyz/modules/shared/screens/user_info.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool checkUser;
  const HomeScreen({super.key, this.checkUser = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    Map<String, dynamic> deviceData = deviceInfo.data;

    return deviceData;
  }

  updateFcmToken() async {
    String fcmToken = await FirebaseFcmManager().getFcmToken();
    Map<String, dynamic> deviceData = await getDeviceInfo();
    await supabase
        .from('users')
        .update({'fcm_token': fcmToken, 'device_info': deviceData})
        .eq('uid', supabase.auth.currentUser!.id)
        .select("fcm_token");
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
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                color: CustomColors.white,
                context: context,
                position: const RelativeRect.fromLTRB(100, 90, 15, 0),
                items: [
                  const PopupMenuItem(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.analytics_outlined),
                        SizedBox(width: 10),
                        Text('Analytics'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 10),
                        Text('Account'),
                      ],
                    ),
                  ),
                ],
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CallendarView(),
              SizedBox(height: 20),
              YourRecordSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
