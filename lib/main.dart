import 'package:app/tabs/filter-tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'package:app/models/bundle.dart';
import 'package:app/stores/global.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPL Points Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PointsViewer(title: 'Flutter Demo Home Page'),
    );
  }

}

class PointsViewer extends StatefulWidget {
  PointsViewer({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PointsViewerState createState() => _PointsViewerState();
}

class _PointsViewerState extends State<PointsViewer> with SingleTickerProviderStateMixin {

  Future<Bundle> data;

  @override
  Widget build(BuildContext ctx) =>
      MultiProvider(
        providers: [
          Provider<GlobalStore>(
              builder: (_) => GlobalStore()
          )
        ],
        child: Scaffold(
            body: BodyWidget()
        )
      );

}

class BodyWidget extends StatelessWidget {
    @override
    Widget build(BuildContext ctx) => Observer(
        builder: (_) {
          final global = Provider.of<GlobalStore>(ctx);

          switch (global.bundle.status) {
            case FutureStatus.pending:
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading Skiers...')
                  ]);
            case FutureStatus.rejected:
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Load Failed...')
                  ]);
            case FutureStatus.fulfilled:
             return FilterTabbar();
          }
          return null;
        });
}


