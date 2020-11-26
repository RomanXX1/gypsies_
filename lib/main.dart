import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_room/room_bloc.dart';
import 'package:gypsies/blocs/repository.dart';
import 'package:gypsies/widgets/room_list.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  final socket =
      IOWebSocketChannel.connect('wss://nane.tada.team/ws?username=Роман');

  runApp(MyApp(socket: socket));
}

class MyApp extends StatelessWidget {
  IOWebSocketChannel socket;
  MyApp({this.socket});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Хей, ромалы',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartPage(socket: socket),
    );
  }
}

class StartPage extends StatelessWidget {
  IOWebSocketChannel socket;
  StartPage({this.socket});

  final repository = ObjRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomBloc>(
      create: (context) => RoomBloc(objRepository: repository),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: socket.stream,
            builder: (context, snapshot) {
              return RoomListWidget(socket: socket);
            }),
      ),
    );
  }
}
