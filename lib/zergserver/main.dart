library zergserver;

import 'package:zergserver/loginserver/loginserver.dart' as loginserver;
import 'package:zergserver/zerg/zerg.dart';

main(List<String> arguments) {
  if(arguments.length != 1){
    logDebug("ZergerServer","start argujments errer, only one param surport");
    return ;
  }

  switch(arguments[0]){
    case 'loginserver':{
      loginserver.startServer();
      break;
    }
    default:
      logDebug("ZergerServer","start argujments errer, pleas check the param");
  }
}