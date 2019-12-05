import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:xcp/combined-config-model.dart';

class CombinedConfig extends StatelessWidget {

  final CombinedConfigModel model = CombinedConfigModel();
  @override

  Widget build(BuildContext ctx) {
    return Provider<CombinedConfigModel>.value(
        value: model,
        child: body(ctx)
    );
  }
  Widget body(ctx){
    return Container(
      child: Observer(
        builder: (_)=> Column( children: [
          Text('Combined Point Caculation'),
        Slider(
          value: model.factor,
          min:0,
          max: 100,
          divisions: 100,
          onChanged: (v) => model.factor = v,
        ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
            Text('Distance ${model.factor.floor()}%'),
            Text('Sprint ${100-model.factor.floor()}%'),
          ]),

        ])
));
  }

}
