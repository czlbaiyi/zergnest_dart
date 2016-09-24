part of zerg;

abstract class Router {
  // ...Define instance variables and methods...
  int getRouterType();
  int getRouterRetType();
  List<int> onPacketHandler(List<int> buff);
}