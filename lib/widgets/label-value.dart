import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelValue extends StatelessWidget {
  LabelValue({this.label, this.value, this.labelWidth});

  final double labelWidth;
  final String label;
  final String value;

  @override
  Widget build(BuildContext ctx) {
    return
        Row( children: [
      Container(
          width: labelWidth,
          child: Tooltip(
              message: label,
              child: Text(label + ': ', style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis, softWrap: false,))),
      Tooltip(
          message: value,
          child: Container(child: Text(
            value,
            overflow: TextOverflow.ellipsis, softWrap: false,
          )))
    ]);
  }

  static List<LabelValue> fromList(List<List> labelValueList, double labelWidth) {
    return labelValueList
        .map((it) => LabelValue(label: it[0], value: it[1].toString(), labelWidth: labelWidth))
        .toList();
  }
}
