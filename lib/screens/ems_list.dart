import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';
import 'dart:io';
import 'bluetoothOffScreen.dart';
import 'find_device_screen.dart';

class EmsBlueToothList extends StatefulWidget {
  const EmsBlueToothList({Key? key}) : super(key: key);

  @override
  State<EmsBlueToothList> createState() => _EmsBlueToothListState();
}

class _EmsBlueToothListState extends State<EmsBlueToothList> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Map<String, ScanResult> scanResults = {};

  static final List<String> filterName = ["WOLO-FGPR-P55"];

  @override
  void initState() {
    super.initState();
    flutterBlue.startScan();
    flutterBlue.scanResults.listen((event) {
      for (ScanResult r in event) {
        if (filterName.contains(r.device.name)) {
          scanResults[r.device.name] = r;
          if (r.device.name.length > 0) {
            print("${r.device.name} found! rssi:${r.rssi}");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return const FindDeviceScreen();
          }
          return const BlueToothOffScreen();
        },
      ),
    );
  }
}
