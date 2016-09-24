library loginserver;
import 'dart:io';
import 'package:zergserver/zerg/zerg.dart';
import 'package:zergserver/proto/message.pb.dart';
import 'package:fixnum/fixnum.dart';

part "loginrouter.dart";
part "loginserverdata.dart";

class LoginServer extends module{
  static startServer(){
    LoginServer server = new LoginServer();
    server.load();
    server.start();
    return server;
  }

  void load() {
    logDebug("LoginServer","load begin");
    registerMessageRouter(new LoginRouter());

    logDebug("LoginServer","load sucess");
  }

  void start(){
    logDebug("LoginServer","start begin");
    int port = int.parse(loginServer.split(":")[1]);
    HttpServer
      .bind(InternetAddress.ANY_IP_V4,port)
      .then((server) {
        server.listen((HttpRequest request) {
          if(request.method == 'POST'){
            List<int> bodyS = new List<int>();      // request body byte data
            request.listen(
                (List<int> body){
                  bodyS.addAll(body);
                  },
                onDone: (){
                  List<int> retBuff = doMessageBuffs(bodyS);
                  request.response..write(retBuff)
                            ..close();
                  },
                onError: (e){
                  logDebug("LoginServer",'exeption occured : ${e.toString()}');
                  }
              );
          }
          else{
            request.response..statusCode = HttpStatus.METHOD_NOT_ALLOWED
                            ..write("Unsupported request: ${request.method}.")
                            ..close();
          }
        });
      });
    logDebug("LoginServer","start sucess");
  }

  void destory(){
    logDebug("LoginServer","destory begin");
    
    logDebug("LoginServer","destory sucess");
  }
}

startServer(){
  LoginServer.startServer();
}

