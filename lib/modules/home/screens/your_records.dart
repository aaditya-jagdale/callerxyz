import 'package:callerxyz/modules/home/widgets/record_card.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class YourRecordSection extends StatefulWidget {
  const YourRecordSection({super.key});

  @override
  State<YourRecordSection> createState() => _YourRecordSectionState();
}

class _YourRecordSectionState extends State<YourRecordSection> {
  final supabase = Supabase.instance.client;
  List<RecordModel> records = [];
  getUserRecord() {
    //get user record from the database
    supabase
        .from("user_records")
        .select()
        .eq("uid", supabase.auth.currentUser!.id)
        .select()
        .then((results) {
      debugPrint("${results.length} records fetched");
      setState(() {
        records = results.map((e) => RecordModel.fromJson(e)).toList();
      });
    });
  }

  @override
  void initState() {
    getUserRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Record",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return RecordCard(record: record);
          },
        ),
      ],
    );
  }
}
