import 'package:flutter/material.dart';

class BlueToothOffScreen extends StatefulWidget {
  const BlueToothOffScreen({Key? key}) : super(key: key);

  @override
  _BlueToothOffScreenState createState() => _BlueToothOffScreenState();
}

class _BlueToothOffScreenState extends State<BlueToothOffScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("蓝牙已关闭"),
      ),
    );
  }
}
