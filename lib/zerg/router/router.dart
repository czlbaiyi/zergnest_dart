part of zerg;

abstract class router {
  // ...Define instance variables and methods...
  int getRouterType();
  List<int> onPacketHandler(List<int> buff);
}