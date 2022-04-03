import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../weigets/scan_result_tile.dart';

class FindDeviceScreen extends StatefulWidget {
  const FindDeviceScreen({Key? key}) : super(key: key);

  @override
  _FindDeviceScreenState createState() => _FindDeviceScreenState();
}

class _FindDeviceScreenState extends State<FindDeviceScreen> {
  static final List<String> filterName = ["WOLO-FGPR-P55", "WOLO-GUN"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Devices"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              initialData: [],
              builder: (context, snapshot) => Column(
                children: snapshot.data!
                    .where(
                        (element) => filterName.contains(element.device.name))
                    .map((e) => ScanResultTile(result: e, onTap: () => {}))
                    .toList(),
              ),
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       height: MediaQuery.of(context).size.height * 0.6,
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         ElevatedButton(
            //           onPressed: () async {
            //             await FlutterBlue.instance.stopScan();
            //             FlutterBlue.instance
            //                 .startScan(timeout: const Duration(seconds: 4));
            //           },
            //           child: const Icon(Icons.refresh_rounded),
            //           style: ElevatedButton.styleFrom(
            //             fixedSize: const Size(60, 60),
            //             shape: const CircleBorder(),
            //           ),
            //         ),
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width * 0.05,
            //         )
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                child: const Icon(Icons.stop),
                backgroundColor: Colors.red);
          } else {
            return FloatingActionButton(
              onPressed: () => FlutterBlue.instance
                  .startScan(timeout: const Duration(seconds: 4)),
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
