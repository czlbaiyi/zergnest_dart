part of zerg;


Map<int, router> routerMap = new Map<int,router>();

void registerMessageRouter(router r) {
  int routerId = r.getRouterType();
  if(routerMap.containsKey(routerId)){
    logError("routermanager", "router id:{$routerId} has register");
    return ;
  }
  routerMap[routerId] = r;
}

List<int> doMessageBuffs(List<int> reqBuf){
  PB_CommonMsg reqRouter = new PB_CommonMsg();
  reqRouter.mergeFromBuffer(reqBuf);
  if(!routerMap.containsKey(reqRouter.msgId)){
    logError("routermanager", "doMessageBuffs router id:${reqRouter.msgId} has not register");
    return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,reqRouter.msgId,"opcode is not available");
  }

  List<int> msgBuf = routerMap["reqRouter.msgId"].onPacketHandler(reqRouter.msgBuf); 
	return doCommonMsg(123,msgBuf);
}

List<int> doCommonErrorMsg(SC10000_errorCodeType errorCode, int errRouterId, String errInfo){
  SC10000	router = new SC10000();
	router.errorCode = errorCode;
	router.csOpcode = errRouterId;
	router.errorMsg = errInfo;
  List<int> routerBytes  = router.writeToBuffer();

  PB_CommonMsg	msg = new PB_CommonMsg();
	msg.msgId = messageId;
	msg.opCode = errRouterId;
	msg.msgBuf = routerBytes;
	return msg.writeToBuffer();
}

List<int> doCommonMsg(int opCode, List<int> msgBuf) {
  PB_CommonMsg	msg = new PB_CommonMsg();
	msg.msgId = messageId;
	msg.opCode = opCode;
	msg.msgBuf = msgBuf;
	return msg.writeToBuffer();
}
