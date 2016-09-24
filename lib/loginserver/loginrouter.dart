part of loginserver;

class LoginRouter extends Router{
  static const int _minLen = 8;
  static const int _maxLen = 12;
  static final int _opCode = CS11001_PacketType.PB_PackType.value;
  static final int _retOpCode = SC11002_PacketType.PB_PackType.value;
    
  LoginRouter(){
    assert(SC11002_PacketType.PB_PackType.value == CS11001_PacketType.PB_PackRetType.value);
  }

  int getRouterType(){
    return _opCode;
  }

  int getRouterRetType(){
    return _retOpCode;
  }

  List<int> onPacketHandler(List<int> buff){
    CS11001 msg = new CS11001();
    msg.mergeFromBuffer(buff);
    if(msg.platformType == CS11001_PB_PlatformType.local_login){
      return loginServer(msg.platformAccountId,msg.authId);
    }
    else{
      return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"platform login not surport");
    }
  }

  List<int> loginServer(String accout , String password){        
      if(accout.length <= _minLen || accout.length > _maxLen){
        return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"accout length must min ${_minLen} add max ${_maxLen}");
      }

      if(password.length <= _minLen || password.length > _maxLen){
        return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"password length must min ${_minLen} add max ${_maxLen}");
      }
      
      if(!playerData.containsKey(accout)){
        SC11002 msg = createPlayer(accout,password);
        String gateAdd = getTheAvilabelGateServer();
        if(gateAdd.length <= 0){
          return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"gate server not avilable");
        }
        else{
          msg.gateSeverAdd = gateAdd;
          return doCommonMsg(SC11002_PacketType.PB_PackType.value, msg.writeToBuffer());
        }
      }
      else if(playerData["accout"] == password){
        SC11002 msg = loginScuess(accout,password);
        String gateAdd = getTheAvilabelGateServer();
        if(gateAdd.length <= 0){
          return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"gate server not avilable");
        }
        else{
          msg.gateSeverAdd = gateAdd;
          return doCommonMsg(SC11002_PacketType.PB_PackType.value, msg.writeToBuffer());
        }
      }
      else {
        return doCommonErrorMsg(SC10000_errorCodeType.PB_BuffPraseError,SC11002_PacketType.PB_PackType.value,"password error");
      }
  }

  SC11002 createPlayer(String accout, String password){
    playerData["accout"] = password;
    SC11002 msg = new SC11002();
    msg.sessionId = "123123";
    msg.localPlayerId = new Int64(222222222);
    msg.platformAccountId = "accid";
    msg.platformAccountName = "name";
    return msg;
  }

  SC11002 loginScuess(String accout, String password){
    SC11002 msg = new SC11002();
    msg.sessionId = "123123";
    msg.localPlayerId = new Int64(222222222);
    msg.platformAccountId = "accid";
    msg.platformAccountName = "name";
    return msg;
  }

  String getTheAvilabelGateServer(){
    if(gateServerPlayers.length <= 0){
      return "";
    }

    int min = -1;
    String retAdd = "";
    gateServerPlayers.forEach((String add, int playerCount){
      if(retAdd.length == 0){
        retAdd = add;
        min = playerCount;
      }
      else if(playerCount < min){
        retAdd = add;
      }
    });
    return retAdd;
  }
}