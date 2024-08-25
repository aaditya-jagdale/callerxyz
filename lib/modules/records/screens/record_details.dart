import 'package:callerxyz/modules/records/widget/record_info_list.dart';
import 'package:callerxyz/modules/shared/models/record_model.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:callerxyz/modules/shared/widgets/textfields.dart';
import 'package:callerxyz/riverpod/record_data.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordDetails extends ConsumerStatefulWidget {
  final RecordModel? record;
  const RecordDetails({super.key, this.record});

  @override
  ConsumerState<RecordDetails> createState() => _RecordDetailsState();
}

class _RecordDetailsState extends ConsumerState<RecordDetails> {
  final _controller = TextEditingController();
  bool _loading = true;
  final supabase = Supabase.instance.client;

  infoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.white,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Record Details Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildInfoItem(
                      'Total Dialed',
                      'The total number of calls made.',
                      SvgPicture.asset("assets/phone_outgoing.svg",
                          height: 20, width: 20),
                    ),
                    _buildInfoItem(
                      'Connected',
                      'The number of calls that were answered.',
                      SvgPicture.asset("assets/chat.svg",
                          height: 20, width: 20),
                    ),
                    _buildInfoItem(
                      'Meetings',
                      'The number of scheduled meetings resulting from calls.',
                      SvgPicture.asset("assets/handshake.svg",
                          height: 20, width: 20),
                    ),
                    _buildInfoItem(
                      'Conversions',
                      'The number of successful outcomes (e.g., sales) from meetings.',
                      SvgPicture.asset("assets/confetti.svg",
                          height: 20, width: 20),
                    ),
                    _buildInfoItem(
                      'Dial-to-Connect',
                      'The percentage of dialed calls that resulted in a connection.',
                      const Icon(Icons.info_outline_rounded, size: 20),
                    ),
                    _buildInfoItem(
                      'Connect-to-Meeting',
                      'The percentage of connected calls that resulted in a scheduled meeting.',
                      const Icon(Icons.info_outline_rounded, size: 20),
                    ),
                    _buildInfoItem(
                      'Meeting-to-Conversion',
                      'The percentage of meetings that resulted in a conversion.',
                      const Icon(Icons.info_outline_rounded, size: 20),
                    ),
                    _buildInfoItem(
                      'Dial-to-Meet',
                      'The percentage of dialed calls that resulted in a scheduled meeting.',
                      const Icon(Icons.info_outline_rounded, size: 20),
                    ),
                    _buildInfoItem(
                      'Callbacks',
                      'The number of requests for callbacks received.',
                      SvgPicture.asset("assets/callback.svg",
                          height: 20, width: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description, Widget icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateValueBottomSheet({Function()? onTap}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.record != null) {
        ref
            .read(recordDataController.notifier)
            .initializeRecord(widget.record!);
      }
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _loading
          ? null
          : AppBar(
              automaticallyImplyLeading: true,
              titleSpacing: 0,
              title: Text(
                DateFormat('MMM dd, yyyy').format(
                    DateTime.parse(ref.read(recordDataController).date)),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    infoBottomSheet();
                  },
                  icon: const Icon(Icons.help_outline_rounded),
                ),
              ],
            ),
      body: _loading
          ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  //Total Dialed
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
                              .read(recordDataController.notifier)
                              .updateTotalDialed(int.parse(_controller.text));

                          Navigator.pop(context);
                        },
                      );
                    },
                    onIncremenet: () {
                      ref.read(recordDataController.notifier).dialedIncrement();
                    },
                    onDecrement: () {
                      ref.read(recordDataController.notifier).dialedDecrement();
                    },
                  ),

                  //Connected
                  RecordInfoList(
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset("assets/chat.svg"),
                    ),
                    title: "Connected",
                    textWidget: Text(
                      ref.watch(recordDataController).connected.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      updateValueBottomSheet(
                        onTap: () {
                          ref
                              .read(recordDataController.notifier)
                              .updateConnected(int.parse(_controller.text));

                          Navigator.pop(context);
                        },
                      );
                    },
                    onIncremenet: () {
                      ref
                          .read(recordDataController.notifier)
                          .connectedIncrement();
                    },
                    onDecrement: () {
                      ref
                          .read(recordDataController.notifier)
                          .connectedDecrement();
                    },
                  ),

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

                  //call-to-connect
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Dial-to-Connect",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${(ref.watch(recordDataController).dialToConnect * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                (ref.watch(recordDataController).dialToConnect *
                                            100) <=
                                        10
                                    ? CustomColors.red
                                    : (ref
                                                    .read(recordDataController)
                                                    .dialToConnect *
                                                100) <=
                                            25
                                        ? CustomColors.yellow
                                        : CustomColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

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

                  //meetings
                  RecordInfoList(
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset("assets/handshake.svg"),
                    ),
                    title: "Meetings",
                    textWidget: Text(
                      ref.watch(recordDataController).meetings.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      updateValueBottomSheet(
                        onTap: () {
                          ref
                              .read(recordDataController.notifier)
                              .updateMeetings(int.parse(_controller.text));
                          Navigator.pop(context);
                        },
                      );
                    },
                    onIncremenet: () {
                      ref
                          .read(recordDataController.notifier)
                          .meetingsIncrement();
                    },
                    onDecrement: () {
                      ref
                          .read(recordDataController.notifier)
                          .meetingsDecrement();
                    },
                  ),

                  //Conversions
                  RecordInfoList(
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset("assets/confetti.svg"),
                    ),
                    title: "Conversions",
                    textWidget: Text(
                      ref.watch(recordDataController).conversions.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      updateValueBottomSheet(
                        onTap: () {
                          ref
                              .read(recordDataController.notifier)
                              .updateConversions(int.parse(_controller.text));

                          Navigator.pop(context);
                        },
                      );
                    },
                    onIncremenet: () {
                      ref
                          .read(recordDataController.notifier)
                          .conversionsIncrement();
                    },
                    onDecrement: () {
                      ref
                          .read(recordDataController.notifier)
                          .conversionsDecrement();
                    },
                  ),

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

                  //connect to meet
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Connect-to-Meet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${(ref.watch(recordDataController).connectToMeeting * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ref
                                        .watch(recordDataController)
                                        .connectToMeeting >=
                                    0.25
                                ? CustomColors.green
                                : ref
                                            .read(recordDataController)
                                            .connectToMeeting >=
                                        0.1
                                    ? CustomColors.yellow
                                    : CustomColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //dial to meet
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Dial-to-Meet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${(ref.watch(recordDataController).dialToMeeting * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            color:
                                ref.watch(recordDataController).dialToMeeting >=
                                        0.25
                                    ? CustomColors.green
                                    : ref
                                                .watch(recordDataController)
                                                .dialToMeeting >=
                                            0.10
                                        ? CustomColors.yellow
                                        : CustomColors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

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
                  //Callbacks
                  RecordInfoList(
                    icon: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset("assets/callback.svg"),
                    ),
                    title: "Callbacks",
                    textWidget: Text(
                      ref.watch(recordDataController).callbackReq.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      updateValueBottomSheet(
                        onTap: () {
                          ref
                              .read(recordDataController.notifier)
                              .updateCallbackReq(int.parse(_controller.text));
                          _controller.clear();

                          Navigator.pop(context);
                        },
                      );
                    },
                    onIncremenet: () {
                      ref
                          .read(recordDataController.notifier)
                          .callbackReqIncrement();
                    },
                    onDecrement: () {
                      ref
                          .read(recordDataController.notifier)
                          .callbackReqDecrement();
                    },
                  ),

                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomColors.black10,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.black25.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Meeting to Conversion",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 250),
                                tween: Tween<double>(
                                    begin: 0,
                                    end: ref
                                        .read(recordDataController)
                                        .meetingToConversion),
                                builder: (context, value, _) =>
                                    CircularProgressIndicator(
                                  value: value,
                                  strokeCap: StrokeCap.round,
                                  strokeWidth: 12,
                                  backgroundColor: CustomColors.black25,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          CustomColors.green),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(milliseconds: 250),
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: ref
                                            .read(recordDataController)
                                            .meetingToConversion *
                                        100,
                                  ),
                                  builder: (context, value, _) => Text(
                                    "${value.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.black,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Success Rate",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
