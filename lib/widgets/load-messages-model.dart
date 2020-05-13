import 'dart:async';

import 'package:mobx/mobx.dart';

part 'load-messages-model.g.dart';

class LoadMessagesModel = _LoadMessagesModel with _$LoadMessagesModel;

abstract class _LoadMessagesModel with Store {

  _LoadMessagesModel() {
    t = Timer.periodic(Duration(milliseconds: 1000), (_) => index++);
  }
   Timer t;

  final List<String> _messages = [
    'Loading Points List',
    'Grinding Bases',
    'Selecting Kick Wax',
    'Brushing Bases',
    'Testing Skis',
    'Watching Devon Kershaw on ESPN',
    'Waiting for the next Alex Harvey',
    'Sara Renner... Beckie Scott... Who\'s next?',
    'Gate to Tape: Annihilate'
  ];

  @observable
  int index = 0;

  @computed
  String get  message  => _messages[index % _messages.length];
}