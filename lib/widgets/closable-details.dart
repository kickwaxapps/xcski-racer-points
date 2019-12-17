import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';
import 'package:xcp/widgets/padded-card.dart';

class ClosableDetails extends StatelessWidget {
  final bool closable;
  final String title;
  final Widget child;

  const ClosableDetails({Key key, this.title, this.child, this.closable}) : super(key: key);
  @override
  Widget build(BuildContext ctx) {
    return PaddedCard(child:Column(children: <Widget>[
      Container(
          color: Colors.white30,
          child: Row(children:[
            Expanded(child:Center(child:Text(title, style: TextStyle(color: Colors.grey,fontSize: 20),))),
            closable ? FlatButton(child: Icon(Icons.close), onPressed: () {
              final filterContext = Provider.of<SkierFilterContextModel>(ctx);
              filterContext.selectedSkierId = -1;
            },): Container()
          ])),
      Expanded(
          child: Container(child: child)
      )
    ]));
  }

}
