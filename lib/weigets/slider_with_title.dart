import 'package:flutter/material.dart';

class SliderWithTitle extends StatefulWidget {
  const SliderWithTitle({
    Key? key,
    required this.divValue,
    required this.maxValue,
    required this.title,
  }) : super(key: key);
  final String title;
  final double maxValue;
  final int divValue;

  @override
  _SliderWithTitleState createState() => _SliderWithTitleState();
}

class _SliderWithTitleState extends State<SliderWithTitle> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: SizedBox(
              width: 40,
              child: Text(
                _value.round().toString(),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            fit: FlexFit.tight,
            child: Slider(
              autofocus: true,
              value: _value,
              max: widget.maxValue,
              divisions: widget.divValue,
              label: _value.round().toString(),
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
                print(value.toString());
              },
            ),
          )
        ],
      ),
    );
  }
}
