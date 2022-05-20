import 'package:flutter/material.dart';
import 'package:flutter_vesti_share/flutter_vesti_share.dart';
import 'dart:io' show Platform;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String msg = 'Hi';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('share to WhatsApp'),
                onPressed: () {
                  Share().whatsAppText(msg: msg);
                },
              ),
              callShareCenteriOS(),
            ],
          ),
        ),
      ),
    );
  }

  callShareCenteriOS() {
    return (Platform.isIOS)
        ? ElevatedButton(
            child: Text('share to WhatsApp'),
            onPressed: () {
              Share().whatsAppText(msg: msg, useCallShareCenter: true);
            },
          )
        : Container();
  }
}
