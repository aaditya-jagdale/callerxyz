import 'package:callerxyz/modules/records/widget/record_info_list.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:callerxyz/modules/shared/widgets/textfields.dart';
import 'package:callerxyz/riverpod/record_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecordDetails extends ConsumerStatefulWidget {
  final RecordModel? record;
  const RecordDetails({super.key, this.record});

  @override
  ConsumerState<RecordDetails> createState() => _RecordDetailsState();
}

class _RecordDetailsState extends ConsumerState<RecordDetails> {
  TextEditingController _controller = TextEditingController();

  updateValueBottomSheet({Function()? onTap}) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Wrap(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _controller,
                  title: "Enter updated value",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomPrimaryButton(
                  title: "Submit",
                  onTap: onTap,
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(recordDataController.notifier).updateDate(widget.record!.date);
      ref
          .watch(recordDataController.notifier)
          .updateTotalDialed(widget.record!.dialed);
      ref
          .watch(recordDataController.notifier)
          .updateConnected(widget.record!.connected);
      ref
          .watch(recordDataController.notifier)
          .updateMeetings(widget.record!.meetings);
      ref
          .watch(recordDataController.notifier)
          .updateConversions(widget.record!.conversions);
    });

    if (widget.record != null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: Text(
          ref.read(recordDataController).date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            RecordInfoList(
              icon: SizedBox(
                height: 20,
                width: 20,
                child: SvgPicture.asset("assets/phone_outgoing.svg"),
              ),
              title: "Total Dialed",
              textWidget: Text(
                ref.watch(recordDataController).totalDialed.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                updateValueBottomSheet(
                  onTap: () {
                    ref
                        .watch(recordDataController.notifier)
                        .updateTotalDialed(int.parse(_controller.text));
                    Navigator.pop(context);
                  },
                );
              },
              onIncremenet: () =>
                  ref.watch(recordDataController.notifier).dialedIncrement(),
              onDecrement: () =>
                  ref.watch(recordDataController.notifier).dialedDecrement(),
            ),
          ],
        ),
      ),
    );
  }
}
