import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:xcp/combined-config.dart';
import 'package:xcp/db.dart';
import 'package:xcp/models/bundle.dart';
import 'package:xcp/points-info.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-tabbar.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  init() async {
    await DB().init();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CPL Points Browser',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: init(),
            builder: (_, snp) => snp.connectionState == ConnectionState.done
                ? PointsViewer(title: 'Flutter Demo Home Page')
                : Container()));
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
  Widget build(BuildContext ctx) => Provider<GlobalStore>(
        create: (_) => GlobalStore(),
        child: Scaffold(
            appBar: AppBar(
                title: Text('XCRacer'),centerTitle: true,
            ),
            drawer: DrawWidget(),
            body: SafeArea(child: BodyWidget())),
      );
}

class DrawWidget extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) =>
      Observer(builder: (_) {
        final global = Provider.of<GlobalStore>(ctx);
        final details = global.bundle.value.points;

        switch (global.bundle.status) {
          case FutureStatus.pending:
            return CircularProgressIndicator();
          case FutureStatus.rejected:
            return CircularProgressIndicator();
          case FutureStatus.fulfilled:
            return Drawer(
                child: ListView(children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Image.asset('assets/img/skier192.png',),
                  ),
                  ListTile(
                      title: Text('Share'), trailing: Icon(Icons.share), onTap: () => Share.share('wwww.xcracer.info')),
                  Divider(),
                  Container( height: 200 , child:PointsInfo(details: [
                    details.maleDistance,
                    details.maleSprint,
                    details.femaleDistance,
                    details.femaleSprint
                  ])),
                  Divider(),
                  CombinedConfig(),
                  Divider(),
                  AboutListTile()
                ])
            );
        }

        return
          null;
      });
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => Observer(builder: (_) {
        final global = Provider.of<GlobalStore>(ctx);

        switch (global.bundle.status) {
          case FutureStatus.pending:
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [CircularProgressIndicator(), Text('Loading Skiers...')]));
          case FutureStatus.rejected:
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator(), Text('Load Failed...')]);
          case FutureStatus.fulfilled:
            return FilterTabbar();
        }
        return null;
      });
}
