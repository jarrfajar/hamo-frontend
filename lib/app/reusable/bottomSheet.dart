import 'package:flutter/material.dart';

class RsBottomSheet extends StatefulWidget {
  final double height;
  final void Function() onPressCancel;
  final void Function() onPressConfirm;
  final Widget label;
  final String title;
  final String body;

  const RsBottomSheet({
    Key? key,
    required this.height,
    required this.onPressCancel,
    required this.onPressConfirm,
    required this.label,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  State<RsBottomSheet> createState() => _RsBottomSheetState();
}

class _RsBottomSheetState extends State<RsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: widget.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          Container(
            height: 5,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 10.0),
          const Divider(
            thickness: 2,
            color: Color(0xffeeeeee),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              widget.body,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30.0),

          // BOTTOM
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff1e7ff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: widget.onPressCancel,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xff7210FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff7210FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: widget.onPressConfirm,
                    child: widget.label,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
