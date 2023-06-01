import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.text, required this.sender});
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 75,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(25),
                right: Radius.circular(25),
              )),
          child: Center(child: Text(sender)),
        ).px12().py8(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                width: 500,
                child: Text(text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
