import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/crm/widgets/client_details.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/transitions.dart';
import 'package:flutter/material.dart';

class CrmListTile extends StatelessWidget {
  final ClientModel client;
  const CrmListTile({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rightSlideTransition(context, ClientDetails(client: client));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: CustomColors.black25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "${client.position}, ${client.company}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: CustomColors.black50),
            ),
          ],
        ),
      ),
    );
  }
}
