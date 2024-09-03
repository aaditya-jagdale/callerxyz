import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/crm/widgets/crm_list_tile.dart';
import 'package:flutter/material.dart';

class CRM extends StatefulWidget {
  const CRM({super.key});

  @override
  State<CRM> createState() => _CRMState();
}

class _CRMState extends State<CRM> {
  List<ClientModel> clients = [
    ClientModel(
      name: 'Mark Zuck',
      position: 'Founder',
      company: 'Facebook',
    ),
    ClientModel(
      name: 'Jeff Loki',
      position: 'Designer',
      company: 'Design agency',
    ),
    ClientModel(
      name: 'Lewis Lamb',
      position: 'Sales manager',
      company: 'AZ marketing',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children:
                  clients.map((client) => CrmListTile(client: client)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
