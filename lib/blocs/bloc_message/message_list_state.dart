import 'package:flutter/material.dart';

abstract class MessageListState {}

class MessageLoadingState extends MessageListState {}

class MessageLoadedState extends MessageListState {
  List<dynamic> loadedMessages;
  MessageLoadedState({@required this.loadedMessages})
      : assert(loadedMessages != null);
}

class MessageErrorState extends MessageListState {}
