import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_room/room_bloc.dart';
import 'package:gypsies/blocs/bloc_room/room_event.dart';
import 'package:gypsies/blocs/bloc_room/room_list_state.dart';
import 'package:gypsies/messages.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:web_socket_channel/io.dart';

class RoomListWidget extends StatelessWidget {
  IOWebSocketChannel socket;
  RoomListWidget({this.socket});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final RoomBloc roomBloc = BlocProvider.of<RoomBloc>(context);
    return BlocBuilder<RoomBloc, RoomListState>(
      builder: (context, state) {
        if (state is RoomsStartPage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/top_back.png',
                  width: size.width - (size.width / 3),
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                ),
                ButtonTheme(
                  minWidth: size.width / 1.6,
                  child: MaterialButton(
                    color: Colors.blue[50],
                    child: Text(
                      "ПОЕХАЛИ",
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    elevation: 4.0,
                    onPressed: () {
                      roomBloc.add(RoomLoadEvent());
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RoomsEmptyState) {
          return Text('Нет данных');
        }

        if (state is RoomsLoadedState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Список комнат'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _openAddRoom(context, roomBloc);
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      _refresh(roomBloc);
                    },
                    child: ListView.builder(
                      itemCount: state.loadedRoom.length,
                      itemBuilder: (context, index) => Container(
                        color: index % 2 == 0 ? Colors.white : Colors.blue[50],
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/entry.png',
                            fit: BoxFit.fill,
                          ),
                          title: Text(
                            '${state.loadedRoom[index].name}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.loadedRoom[index].text}',
                              ),
                              Text(
                                'создана: ${state.loadedRoom[index].date_created}',
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Messages(
                                    name: state.loadedRoom[index].name,
                                    socket: socket,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is RoomsLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is RoomsErrorState) {
          return Text('Ошибка загрузки');
        }

        return Text('123');
      },
    );
  }

  Future<Null> _refresh(roomBloc) {
    roomBloc.add(RoomLoadEvent());
  }

  void _openAddRoom(context, roomBloc) {
    TextEditingController edRoom = new TextEditingController();
    TextEditingController edText = new TextEditingController();
    Alert(
        context: context,
        title: 'Создание новой комнаты',
        content: Column(
          children: [
            TextField(
              controller: edRoom,
              decoration: InputDecoration(
                icon: Icon(Icons.border_all),
                labelText: 'Название комнаты',
              ),
            ),
            TextField(
              controller: edText,
              decoration: InputDecoration(
                icon: Icon(Icons.chat),
                labelText: 'Текст сообщения',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              _sendAddRoom(roomBloc, edRoom.text, edText.text);
              Navigator.of(context).pop();
            },
            child: Text(
              'Создать',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Отмена',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void _sendAddRoom(roomBloc, room, text) {
    if (room != '' || text != '') {
      final String data = '{' +
          '"room":' +
          '"' +
          room +
          '", ' +
          '"text":' +
          '"' +
          text +
          '"' +
          '}';
      socket.sink.add(data);
      roomBloc.add(RoomLoadEvent());
    } else {
      // TODO: Обработать вывод сообщения об ошибке
    }
  }
}
