import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/crm/widgets/crm_list_tile.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CRM extends StatefulWidget {
  const CRM({super.key});

  @override
  State<CRM> createState() => _CRMState();
}

class _CRMState extends State<CRM> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isSorting = false;
  List<ClientModel> clients = [];

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
      setState(() {
        clients = response.map((e) => ClientModel.fromJson(e)).toList();
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
        onPressed: () {},
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
                  clients.sort((a, b) => a.name.compareTo(b.name));
                } else {
                  clients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                }
                _isSorting = !_isSorting;
              });
            },
            icon: Icon(Icons.filter_list),
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      return CrmListTile(
                        client: clients[index],
                        onReturn: () => getCrmData(),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
