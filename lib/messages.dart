import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_message/message_bloc.dart';
import 'package:gypsies/blocs/repository.dart';
import 'package:gypsies/widgets/messages_list.dart';
import 'package:web_socket_channel/io.dart';

class Messages extends StatelessWidget {
  String name;
  IOWebSocketChannel socket;
  Messages({this.name, this.socket});

  @override
  Widget build(BuildContext context) {
    final repository = ObjRepository();
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(objRepository: repository, room: name),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Комната ' + name),
        ),
        body: MessagesListWidget(
          name: name,
          socket: socket,
        ),
      ),
    );
  }
}
