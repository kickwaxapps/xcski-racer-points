import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:xcp/combined-config.dart';
import 'package:xcp/db.dart';
import 'package:xcp/models/bundle.dart';
import 'package:xcp/points-info.dart';
import 'package:xcp/stores/global.dart';
import 'package:xcp/tabs/filter-tabbar.dart';
import 'package:xcp/widgets/load-messages.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
    await DB().init();
    runApp(MyApp());
}


class MyApp extends StatelessWidget {
  init() async {
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
                ? PointsViewer(title: 'XC Racer')
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
            drawer: DrawerWidget(),
            body: SafeArea(child: BodyWidget())),
      );
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) =>
      Observer(builder: (_) {
        final global = Provider.of<GlobalStore>(ctx);
        final s = global.bundle.status;
        final details = global.bundle.value?.points;
            return Drawer(
                child: ListView(children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Image.asset('assets/img/skier192.png',),
                  ),
                  ListTile(title: Text('Share'), trailing: Icon(Icons.share), onTap: () => Share.share('www.xcracer.info')),
                  ListTile(title: Text('Points Calculator'), trailing: Icon(Icons.open_in_new), onTap: () =>launch('https://yourpoints.surge.sh')),
                  ListTile(title: Text('XCRacer website'), trailing: Icon(Icons.open_in_new), onTap: () =>launch('https://www.xcracer.info')),
                  ListTile(title: Text('Nordiq Canada Points'), trailing: Icon(Icons.open_in_new), onTap: () =>launch('https://nordiqcanada.ca/races/point-list/')),
                  Divider(),
                  ListTile(title: Text('Refresh Rolling Points') , onTap: () => global.loadBundle(), trailing: Icon(Icons.refresh), ),
                  ListTile(title: Text('Reload Everything') , onTap: () => global.loadBundle(forceReload:true), trailing: Icon(Icons.cached) ),
                  Divider(),

                  Container( height: 200 , child: s == FutureStatus.fulfilled ? PointsInfo(details: [
                    details.maleDistance,
                    details.maleSprint,
                    details.femaleDistance,
                    details.femaleSprint
                  ]) : Center(child:CircularProgressIndicator()) ),
                  Divider(),
                  CombinedConfig(),
                  Divider(),
                  AboutListTile()
                ])
            );
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
                    children:  [CircularProgressIndicator(), LoadMessages()]));
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
