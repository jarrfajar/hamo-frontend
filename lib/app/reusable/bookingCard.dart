import 'package:flutter/material.dart';

class BookingsCard extends StatefulWidget {
  final String valueDate;
  final String valueHours;
  final String valueDescription;
  final String valueAddress;

  const BookingsCard({
    Key? key,
    required this.valueDate,
    required this.valueHours,
    required this.valueDescription,
    required this.valueAddress,
  }) : super(key: key);

  @override
  State<BookingsCard> createState() => _BookingsCardState();
}

class _BookingsCardState extends State<BookingsCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Date'),
            Text(
              widget.valueDate,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hours'),
            Text(
              widget.valueHours,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        const Text("Description"),
        const SizedBox(height: 10.0),
        TextFormField(
          readOnly: true,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.7,
                color: Color(0xff7210FF),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            fillColor: const Color(0xfffafafa),
            hintText: widget.valueDescription,
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        const Text("Address"),
        const SizedBox(height: 10.0),
        TextFormField(
          readOnly: true,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.7,
                color: Color(0xff7210FF),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            fillColor: const Color(0xfffafafa),
            hintText: widget.valueAddress,
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
