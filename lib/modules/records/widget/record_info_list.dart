import 'package:callerxyz/modules/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordInfoList extends ConsumerStatefulWidget {
  final Widget icon;
  final String title;
  final Widget textWidget;
  final Function()? onTap;
  final Function()? onIncremenet;
  final Function()? onDecrement;

  const RecordInfoList({
    super.key,
    required this.icon,
    required this.title,
    required this.textWidget,
    this.onTap,
    this.onIncremenet,
    this.onDecrement,
  });

  @override
  ConsumerState<RecordInfoList> createState() => _RecordInfoListState();
}

class _RecordInfoListState extends ConsumerState<RecordInfoList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CustomColors.black10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.icon,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.onDecrement,
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 8),
                widget.textWidget,
                const SizedBox(width: 8),
                IconButton(
                  onPressed: widget.onIncremenet,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
