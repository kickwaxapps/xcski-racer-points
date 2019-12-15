import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaddedCard extends StatelessWidget {
  final Widget child;

  const PaddedCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(margin: EdgeInsets.all(5), child: Padding(padding: const EdgeInsets.all(10), child: child)));
  }
}
