part of loginserver;

enum eLoginType{
  eLoginType_Local,
  eLoginType_Platform,
}

Map<String ,String> playerData = new Map<String ,String>();
eLoginType loginType;
Map<String, int> gateServerPlayers = new Map<String, int>();

