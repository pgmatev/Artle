import 'package:flutter/material.dart';

class DrawingTaskWidget extends StatelessWidget {
  const DrawingTaskWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: const Text(
            "How do you feel about this song?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        ),
        Container(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            child: const Image(
              image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              height: 150,
              width: 150,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 20),
        ),
        const Text(
          "Drake - God's plan",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(
          child: TextField(
            maxLines: 8,
            decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
          ),
        ),
      ],
    );
  }
}