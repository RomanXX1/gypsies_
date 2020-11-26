import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_message/message_bloc.dart';
import 'package:gypsies/blocs/bloc_message/message_event.dart';
import 'package:gypsies/blocs/bloc_message/message_list_state.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:web_socket_channel/io.dart';

class MessagesListWidget extends StatelessWidget {
  String name;
  IOWebSocketChannel socket;
  MessagesListWidget({this.name, this.socket});

  @override
  Widget build(BuildContext context) {
    final MessageBloc messagesBloc = BlocProvider.of<MessageBloc>(context);
    messagesBloc.add(MessageLoadEvent());
    return BlocBuilder<MessageBloc, MessageListState>(
      builder: (context, state) {
        if (state is MessageLoadedState) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _openAddMessage(context, messagesBloc);
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      _refresh(messagesBloc);
                    },
                    child: ListView.builder(
                      itemCount: state.loadedMessages.length,
                      itemBuilder: (context, index) => Container(
                        color: index % 2 == 0 ? Colors.white : Colors.blue[50],
                        child: ListTile(
                          title: Text('${state.loadedMessages[index].text}'),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.loadedMessages[index].user}',
                              ),
                              Text(
                                'создана: ${state.loadedMessages[index].date_created}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is MessageLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MessageErrorState) {
          return Text('Ошибка загрузки');
        }

        return Text('123');
      },
    );
  }

  Future<Null> _refresh(roomBloc) {
    roomBloc.add(MessageLoadEvent());
  }

  void _openAddMessage(context, roomBloc) {
    TextEditingController edText = new TextEditingController();
    Alert(
        context: context,
        title: 'Добавление сообщения',
        content: Column(
          children: [
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
              _sendAddMessage(roomBloc, name, edText.text);
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

  void _sendAddMessage(roomBloc, room, text) {
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
      roomBloc.add(MessageLoadEvent());
    } else {
      // TODO: Обработать вывод сообщения об ошибке
    }
  }
}
