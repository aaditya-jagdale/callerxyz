import 'package:callerxyz/modules/analytics/pages/analytics.dart';
import 'package:callerxyz/modules/crm/screens/crm.dart';
import 'package:callerxyz/modules/home/screens/calendar_view.dart';
import 'package:callerxyz/modules/home/screens/profile_page.dart';
import 'package:callerxyz/modules/home/screens/your_records.dart';
import 'package:callerxyz/modules/local_notifications.dart';
import 'package:callerxyz/modules/shared/widgets/transitions.dart';
import 'package:callerxyz/riverpod/fcm_init.dart';
import 'package:callerxyz/modules/shared/screens/user_info.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/riverpod/records_riverpod.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  List<PendingNotificationRequest> pendingNotifications = [];
  List<PendingNotificationRequest> activeNotifications = [];

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.checkUser) checkUser();
      pendingNotifications = await LocalNotifications.getPendingNotifications();
      updateFcmToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                  if (ref.watch(yourRecordsProvider).records.isNotEmpty)
                    PopupMenuItem(
                      onTap: () {
                        fadeTransition(
                          context,
                          Analytics(
                            records: ref.watch(yourRecordsProvider).records
                              ..sort((a, b) => DateTime.parse(b.date)
                                  .compareTo(DateTime.parse(a.date))),
                          ),
                        );
                      },
                      child: const Row(
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
                          builder: (context) => const CRM(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.list),
                        SizedBox(width: 10),
                        Text('CRM'),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CallendarView(),
              SizedBox(height: 20),
              YourRecordSection(),
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
            ],
          ),
        ),
      ),
    );
  }
}
