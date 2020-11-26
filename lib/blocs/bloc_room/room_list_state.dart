import 'package:flutter/material.dart';

abstract class RoomListState {}

class RoomsEmptyState extends RoomListState {}

class RoomsLoadingState extends RoomListState {}

class RoomsLoadedState extends RoomListState {
  List<dynamic> loadedRoom;
  RoomsLoadedState({@required this.loadedRoom}) : assert(loadedRoom != null);
}

class RoomsErrorState extends RoomListState {}

class RoomsStartPage extends RoomListState {}
