import 'package:flutter/material.dart';

class NotificationBar extends StatefulWidget {
  const NotificationBar({super.key});

  @override
  State<NotificationBar> createState() => _NotificationBarState();
}

class _NotificationBarState extends State<NotificationBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.close_rounded,size: 30,))),
            Center(
              child: Text(
                "No notifications",
                style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
