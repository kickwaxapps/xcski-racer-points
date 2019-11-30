import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LabelValue extends StatelessWidget {

  LabelValue({this.label, this.value, this.labelWidth});

  final double labelWidth;
  final String label;
  final String value;
  @override
  Widget build(BuildContext ctx) {
    return FittedBox( child:
      Flex( direction: Axis.horizontal ,children: [Container( width: labelWidth, child: Text(label+': ', style: TextStyle(color: Colors.grey))), Text(value),Center(child:Container(height: 10, child: VerticalDivider()))] ));
  }

  static List<LabelValue> fromList(List<List> labelValueList, double labelWidth) {
    print(labelValueList);
    return labelValueList.map((it) =>
        LabelValue(label: it[0], value: it[1].toString(), labelWidth: labelWidth)).toList();
  }
}