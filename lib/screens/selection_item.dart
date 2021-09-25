import 'package:flutter/material.dart';
import 'package:mobilef2/style/color_constants.dart';

class SelectionItem extends StatefulWidget {
  const SelectionItem({
    Key? key,
    required this.title,
    required this.onSelect,
  }) : super(key: key);

  final String title;
  final Function(String) onSelect;

  @override
  _SelectionItemState createState() => _SelectionItemState();
}

class _SelectionItemState extends State<SelectionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onSelect(widget.title);
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          width: double.infinity,
          child: Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 20),
            ),
          )),
          decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}
