import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../screens/device_screen.dart';

class ScanResultTile extends StatelessWidget {
  ScanResultTile({Key? key, required this.result, required this.onTap})
      : super(key: key);

  final ScanResult result;
  final VoidCallback onTap;

  int _flag = 1;

  String getNiceHexArray(List<int> bytes) {
    return '${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}'
        .toUpperCase();
  }

  String getNiceManufacturerData(Map<int, List<int>> data) {
    if (data.isEmpty) {
      return 'N/A';
    }
    List<String> res = [];
    data.forEach((id, bytes) {
      res.add(
          '[${id.toRadixString(16).padLeft(2, '0').toUpperCase().substring(0, 2)}, ${id.toRadixString(16).padLeft(2, '0').toUpperCase().substring(2, 4)}, ${getNiceHexArray(bytes)}]');
    });
    return res.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_tree_sharp),
      title: Text(result.device.name),
      subtitle: Text(
          getNiceManufacturerData(result.advertisementData.manufacturerData)
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(", ", ":")),
      trailing: ElevatedButton(
        child: StreamBuilder<BluetoothDeviceState>(
          stream: result.device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.data) {
              case BluetoothDeviceState.connected:
                _flag = 1;
                // mOnPressed = () {
                //   print("disconnect");
                //   result.device.disconnect();
                // };
                return const Text("断开");
              case BluetoothDeviceState.disconnected:
                _flag = 2;
                // print("connect");
                // mOnPressed = () {
                //   print("connect");
                //   result.device.connect();
                // };
                return const Text("连接");
              default:
                _flag = 3;
                // mOnPressed = () {
                //   print("connectting");
                // };
                return const Text("连接中");
            }
          },
        ),
        onPressed: () {
          switch (_flag) {
            case 1:
              print("disconnect");
              result.device.disconnect();
              break;
            case 2:
              print("connect");
              result.device.connect();
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, ani1, ani2) {
                    return DeviceScreen(device: result.device);
                  },
                ),
              );
              break;
            case 3:
              print("connectting");
              break;
          }
        },
      ),
    );
  }
}
