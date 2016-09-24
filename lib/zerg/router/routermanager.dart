part of zerg;


Map<int, Router> routerMap = new Map<int,Router>();

void registerMessageRouter(Router r) {
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
  if(!routerMap.containsKey(reqRouter.opCode)){
    logError("routermanager", "doMessageBuffs router id:${reqRouter.opCode} has not register");
    return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,reqRouter.opCode,"opcode is not available");
  }

  int reOpCode = routerMap[reqRouter.opCode].getRouterType();
  List<int> msgBuf = routerMap[reqRouter.opCode].onPacketHandler(reqRouter.msgBuf); 
	return doCommonMsg(reOpCode,msgBuf);
}

List<int> doCommonErrorMsg(SC10000_errorCodeType errorCode, int opCode, String errInfo){
  SC10000	router = new SC10000();
	router.errorCode = errorCode;
	router.csOpcode = opCode;
	router.errorMsg = errInfo;
  List<int> routerBytes  = router.writeToBuffer();

  PB_CommonMsg	msg = new PB_CommonMsg();
	msg.msgId = messageId;
	msg.opCode = SC10000_PacketType.PB_PackRetType.value;
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
