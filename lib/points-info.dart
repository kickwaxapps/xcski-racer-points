import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xcp/models/points-bundle.dart';
import 'package:xcp/widgets/label-value.dart';

import 'package:date_format/date_format.dart';
import 'package:xcp/widgets/padded-card.dart';


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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Loaded Point Lists', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        SizedBox(
          height: 160,
          // you may want to use an aspect ratio here for tablet support
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
    return Center(
      child: PaddedCard(
            child: Column(
              children: [ Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(details.title),
              ),
               ...LabelValue.fromList([
                 ['Published', dtFmt(details.pubDate)],
                [details.sex == 'M' ? 'Men\'s' : 'Women\'s', details.sprintOrDistance == 'S' ? 'Sprint' : 'Distance'],
                ['Type', details.type],
                ['Races From', dtFmt(details.fromDate)],
                ['Races To', dtFmt(details.toDate)]

                ],

                   100).map((it)=>Row(children: [it],))
            ],)  ,
          ),
    );
  }
}
