import 'package:callerxyz/modules/crm/models/client_model.dart';
import 'package:callerxyz/modules/crm/widgets/client_details_list_tile.dart';
import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:callerxyz/modules/shared/widgets/custom_buttons.dart';
import 'package:callerxyz/modules/shared/widgets/textfields.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientDetails extends StatefulWidget {
  final ClientModel client;
  const ClientDetails({super.key, required this.client});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final nameController = TextEditingController();
  final bottomSheetTextController = TextEditingController();
  final supabase = Supabase.instance.client;
  final notesController = TextEditingController();

  String selectedPosition = "";
  String selectedCompany = "";
  String selectedStatus = "";
  String selectedNumber = "";
  DateTime? selectedReminder;

  customTextbottomSheet({Function()? onTap}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
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
                  controller: bottomSheetTextController,
                  title: "Enter Updated Value",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomPrimaryButton(
                  title: "Update",
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

  void selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          selectedReminder = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Converted',
                style: TextStyle(color: Colors.cyan, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  selectedStatus = "Converted";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Meeting',
                style: TextStyle(color: CustomColors.yellow, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  selectedStatus = "Meeting";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Connected',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  selectedStatus = "Connected";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'No status',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  selectedStatus = "";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Rejected',
                style: TextStyle(color: CustomColors.red, fontSize: 18),
              ),
              onTap: () {
                setState(() {
                  selectedStatus = "Rejected";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  uploadData() async {
    //upload data to supabase
    supabase.from('clients_data').upsert({
      'name': nameController.text,
      'notes': notesController.text.trim(),
      'phone_number': bottomSheetTextController.text,
      'status': selectedStatus,
      'reminder': DateFormat("yyyy-MM-dd").format(selectedReminder!),
    });
  }

  @override
  void initState() {
    nameController.text = widget.client.name;
    selectedPosition = widget.client.position;
    selectedCompany = widget.client.company;
    selectedNumber = widget.client.phone_number;
    notesController.text = widget.client.notes;
    selectedStatus = widget.client.status;
    selectedReminder = widget.client.reminder.isNotEmpty
        ? DateTime.parse(widget.client.reminder)
        : null;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    bottomSheetTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: CustomColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    maxLines: 1,
                    style: TextStyle(fontSize: 40, height: 1),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Notes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    controller: notesController,
                    maxLines: 5,
                    minLines: 1,
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add notes",
                      hintStyle: TextStyle(color: CustomColors.black25),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: DottedLine(
                      dashColor: CustomColors.black50,
                      dashGapLength: 6,
                      dashLength: 6,
                      lineThickness: 1,
                      dashRadius: 0,
                    ),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/person.svg"),
                    placeholder: "Position",
                    title: selectedPosition,
                    onTap: () {},
                    onLongPress: () => customTextbottomSheet(
                      onTap: () {
                        setState(() {
                          selectedPosition = bottomSheetTextController.text;
                        });
                        bottomSheetTextController.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/building.svg"),
                    placeholder: "Company",
                    title: selectedCompany,
                    onTap: () {},
                    onLongPress: () => customTextbottomSheet(
                      onTap: () {
                        setState(() {
                          selectedCompany = bottomSheetTextController.text;
                        });
                        bottomSheetTextController.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/pentagon.svg"),
                    placeholder: "Status",
                    title: selectedStatus,
                    onTap: () => _showStatusBottomSheet(context),
                    onLongPress: () => _showStatusBottomSheet(context),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/calendar.svg"),
                    placeholder: "Add Reminder",
                    title: selectedReminder != null
                        ? DateFormat("MMM dd, yyyy - hh:mm a")
                            .format(selectedReminder!)
                        : "",
                    onTap: () => selectDateTime(),
                    onLongPress: () => selectDateTime(),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/phone.svg"),
                    placeholder: "Phone number",
                    title: selectedNumber,
                    subtitle: "Tap to copy",
                    onTap: () {
                      if (selectedNumber.isEmpty) {
                        customTextbottomSheet(
                          onTap: () {
                            setState(() {
                              selectedNumber = bottomSheetTextController.text;
                            });
                            bottomSheetTextController.clear();
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        //copy to clipboard
                        Clipboard.setData(ClipboardData(text: selectedNumber));
                      }
                    },
                    onLongPress: () => customTextbottomSheet(
                      onTap: () {
                        setState(() {
                          selectedNumber = bottomSheetTextController.text;
                        });
                        bottomSheetTextController.clear();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/recording.svg"),
                    placeholder: "Add call recording",
                  ),
                  ClientDetailsListTile(
                    icon: SvgPicture.asset("assets/attachment.svg"),
                    placeholder: "Add a document",
                  ),
                  const Expanded(child: SizedBox(height: 50)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "Long press to edit",
                        style: TextStyle(color: CustomColors.black50),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
