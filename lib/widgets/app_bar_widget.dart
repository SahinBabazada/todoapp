import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const AppBarWidget({
    super.key,
    required this.currentColor,
  }) : preferredSize = const Size.fromHeight(60.0);

  final Color currentColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "TODO",
        style: TextStyle(fontSize: 16.0),
      ),
      backgroundColor: currentColor,
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.search),
        ),
      ],
      elevation: 0.0,
    );
  }
}
