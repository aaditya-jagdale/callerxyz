import 'package:callerxyz/crm_riverpod.dart';
import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/crm/widgets/crm_list_tile.dart';
import 'package:callerxyz/modules/local_notifications.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

class CRM extends ConsumerStatefulWidget {
  const CRM({super.key});

  @override
  ConsumerState<CRM> createState() => _CRMState();
}

class _CRMState extends ConsumerState<CRM> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isSorting = false;

  getCrmData() async {
    setState(() {
      _isLoading = true;
    });
    await supabase
        .from('crm')
        .select('*')
        .eq('uid', supabase.auth.currentUser!.id)
        .order('createdAt', ascending: false)
        .then((response) {
      ref
          .read(clientsProvider.notifier)
          .setClients(response.map((e) => ClientModel.fromJson(e)).toList());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getCrmData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        onPressed: () {
          LocalNotifications.showScheduleNotification(
            title: "Caller XYZ",
            body: "Fuck you at 12:12",
            payload: "lmao",
          );
          // rightSlideTransition(
          //   context,
          //   const ClientDetails(
          //     isNewClient: true,
          //     client: ClientModel(
          //       id: -1,
          //       name: "",
          //     ),
          //   ),
          // );
        },
        child: Icon(
          Icons.add,
          color: CustomColors.white,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: const Text(
          "CRM",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_isSorting) {
                  ref.read(clientsProvider.notifier).sortByName();
                } else {
                  ref.read(clientsProvider.notifier).sortByCreatedAt();
                }
                _isSorting = !_isSorting;
              });
            },
            icon: _isSorting
                ? SvgPicture.asset("assets/filter_alphabetical.svg")
                : SvgPicture.asset("assets/filter.svg"),
          ),
        ],
      ),
      body: _isLoading
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => getCrmData(),
              child: ListView.builder(
                itemCount: ref.watch(clientsProvider).length,
                itemBuilder: (context, index) {
                  return CrmListTile(
                    client: ref.watch(clientsProvider)[index],
                  );
                },
              ),
            ),
    );
  }
}
