import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xcp/models/points-bundle.dart';
import 'package:xcp/widgets/label-value.dart';

import 'package:date_format/date_format.dart';


class PointsInfo extends StatelessWidget {
  final List<PointListDetail> _details;

  const PointsInfo({Key key, details: const <PointListDetail>[]})
      : _details = details,
        super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        itemBuilder: (BuildContext context, int index) {
          if (index % 2 == 0) {
            return _carouselBody(context, index ~/ 2);
          } else {
            return Divider();
          }
        });
  }

  Widget _carouselBody(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Loaded Point Lists'),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _item(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget _item(ctx, carouselIndex, itemIndex) {
    final details = _details[itemIndex % 4];
    final dtFmt = (dt) => formatDate(dt, [mm, '/', dd, '/', yy]);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Column(
            children: [ Text(details.title),
             ...LabelValue.fromList([
               ['Published', dtFmt(details.pubDate)],
              [details.sex == 'M' ? 'Men\'s' : 'Women\'s', details.sprintOrDistance == 'S' ? 'Sprint' : 'Distance'],
              ['Type', details.type],
              ['Races From', dtFmt(details.fromDate)],
              ['Races To', dtFmt(details.toDate)]

              ],

                 100).map((it)=>Row(children: [it],))
          ],)  ,
        ));
  }
}
