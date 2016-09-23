library zerg;

import 'package:zergserver/proto/message.pb.dart';

part 'conf/conf.dart';
part 'log/log.dart';
part 'module/module.dart';
part 'router/router.dart';
part 'router/routermanager.dart';

int beginMsgId = 0;

int get messageId{
  return ++beginMsgId;
}