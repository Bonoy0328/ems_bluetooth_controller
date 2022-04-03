import 'package:ems_bluetooth_controller/weigets/knob_widget/controller/knob_controller.dart';
import 'package:ems_bluetooth_controller/weigets/knob_widget/utils/knob_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../weigets/knob_widget/knob_widget.dart';
import '../weigets/slider_with_title.dart';
import 'dart:async';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final double _minimum = 10;
  final double _maximum = 40;

  bool _startSendData = false;

  late KnobController _knobController;
  double _knobValue = 1600;

  late double _oldvalue;

  late List<BluetoothService> services;
  late BluetoothService service;
  late BluetoothCharacteristic characteristic;

  int _getBcc(List<int> a) {
    int res = 0;
    for (int i in a) {
      res ^= i;
    }
    return res;
  }

  List<int> _getArray(int speed) {
    List<int> dList = [
      0x5A,
      0x0B,
      0x11,
      0x06,
      0x40,
      0x08,
      0x98,
      0x0A,
      0x02,
      0x02,
      0x00
    ];
    dList[3] = (speed / 0x100).round();
    dList[4] = (speed % 0x100).round();
    dList[5] = (speed / 0x100).round();
    dList[6] = (speed % 0x100).round();
    dList[10] = _getBcc(dList);
    return dList;
  }

  void tCallBack() {
    Timer.periodic(const Duration(milliseconds: 100), (_) async {
      // _timeCnt++;
      // print("object " + _timeCnt.t
      if (_startSendData) {
        characteristic.write(_getArray(_knobValue.round()),
            withoutResponse: true);
        _startSendData = false;
      }
    });
  }

  void startTimer() async {
    var _duration = const Duration(milliseconds: 100);
    Timer(_duration, tCallBack);
  }

  void valueChangedListener(double value) async {
    if (mounted) {
      setState(() {
        if (_oldvalue > value) {
          _knobValue--;
          if (_knobValue < 0) _knobValue = 0;
        } else {
          _knobValue++;
        }
        _oldvalue = value;
        print("now value : " + _knobValue.toString());
        _startSendData = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _knobValue = 1600;
    _oldvalue = _minimum;
    _knobController = KnobController(
      initial: _minimum,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: 0,
      endAngle: 360,
    );
    _knobController.addOnValueChangedListener(valueChangedListener);
    widget.device.discoverServices();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.device.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SliderWithTitle(divValue: 20, maxValue: 480, title: "挡位"),
            const SliderWithTitle(
                divValue: 20, maxValue: 1000, title: "单脉冲放电时间"),
            const SliderWithTitle(divValue: 20, maxValue: 255, title: "放电频率"),
            const SliderWithTitle(divValue: 20, maxValue: 60, title: "持续时间"),
            const SliderWithTitle(divValue: 20, maxValue: 60, title: "间隔时间"),
            Container(
              width: double.infinity,
              height: 350,
              color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("SPEED: " + _knobValue.round().toString() + " /RPM"),
                  Center(
                    child: Knob(
                      controller: _knobController,
                      style: const KnobStyle(
                        labelOffset: 10,
                        tickOffset: 10,
                        showLabels: false,
                        minorTicksPerInterval: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("更新"),
        onPressed: () async {
          widget.device.discoverServices();
          services = await widget.device.services.first;
          service = services.where((element) {
            return element.uuid.toString().contains("efe9");
          }).first;
          characteristic = service.characteristics.where((element) {
            return element.uuid.toString().contains("efea");
          }).first;
          characteristic.write(_getArray(1600), withoutResponse: true);
        },
      ),
    );
  }
}
