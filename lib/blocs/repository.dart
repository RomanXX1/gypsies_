import 'package:gypsies/models/message.dart';
import 'package:gypsies/models/room.dart';
import 'package:gypsies/server_apis/server_api.dart';

class ObjRepository {
  RoomProvider _roomProvider = RoomProvider();
  MessageProvider _messageProvider = MessageProvider();

  Future<List<Room>> getRooms() => _roomProvider.fetchRooms();
  Future<List<Message>> getMessages(String room) =>
      _messageProvider.fetchMessages(room);
}
