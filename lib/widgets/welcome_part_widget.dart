import 'package:flutter/material.dart';

class WelcomePart extends StatelessWidget {
  const WelcomePart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Icon(
              Icons.account_circle,
              size: 45.0,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
            child: Text(
              "Hello, Jane.",
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Text(
            "Looks like feel good.",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "You have 3 tasks to do today.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
