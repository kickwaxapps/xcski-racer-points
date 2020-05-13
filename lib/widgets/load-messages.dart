import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xcp/widgets/load-messages-model.dart';


class LoadMessages extends StatelessWidget {
  final model = LoadMessagesModel();

  @override
  Widget build(BuildContext context) {
    return Observer(builder:(_){
      return AnimatedSwitcher(
          child: Text( model.message, key: ValueKey(model.index)),
          duration: Duration(milliseconds: 500),
     );
    });
  }
}

