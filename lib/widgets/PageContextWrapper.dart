import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/skier-filter-context-model.dart';

class PageContextWrapper extends StatelessWidget{
  PageContextWrapper(this._ctx, this._title, this._fn);
  final _fn;
  final _title;
  final _ctx;

  @override
  Widget build(BuildContext ctx) {
    return MultiProvider(
        providers: [
          Provider<GlobalStore>.value(value: Provider.of<GlobalStore>(_ctx)),
          Provider<SkierFilterContextModel>.value(value: Provider.of<SkierFilterContextModel>(_ctx))
        ],
        child: Scaffold(
            appBar: AppBar(title: Text(_title),),
            body: _fn())
    );
  }
}