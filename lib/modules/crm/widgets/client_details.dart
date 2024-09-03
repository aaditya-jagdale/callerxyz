import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';

class ClientDetails extends StatefulWidget {
  final ClientModel client;
  const ClientDetails({super.key, required this.client});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final nameController = TextEditingController();
  bool expandNotes = false;

  @override
  void initState() {
    nameController.text = widget.client.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              maxLines: 1,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 35,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        expandNotes = !expandNotes;
                      });
                    },
                    child: Text(
                      expandNotes ? "View less" : "View more",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.black50),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              maxLines: expandNotes ? null : 3,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Add notes",
                hintStyle: TextStyle(color: CustomColors.black25),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Call"),
              trailing: Icon(Icons.phone),
            ),
          ],
        ),
      ),
    );
  }
}
