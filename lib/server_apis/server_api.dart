import 'dart:convert';
import 'package:gypsies/models/message.dart';
import 'package:gypsies/models/room.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RoomProvider {
  Future<List<Room>> fetchRooms() async {
    final response = await http.get('https://nane.tada.team/api/rooms');
    print('Ответ сервера (комнаты) - ${response?.body}');

    if (response.statusCode == 200) {
      final Room_API room_api = Room_API.fromJson(json.decode(response.body));

      List<Room> rooms = new List<Room>();
      room_api.result.forEach((element) {
        DateTime date_created = DateTime.parse(element.lastMessage.created);
        String str_date = DateFormat('dd.MM.yy kk:mm').format(date_created);
        rooms.add(new Room(
            name: element.name,
            text: element.lastMessage.text,
            date_created: str_date));
      });

      return rooms.toList();
    } else {
      return Future.error('Не удалось соединиться с сервером');
    }
  }
}

class MessageProvider {
  Future<List<Message>> fetchMessages(String room) async {
    final response =
        await http.get('https://nane.tada.team/api/rooms/' + room + '/history');
    print('Ответ сервера (комнаты) - ${response?.body}');

    if (response.statusCode == 200) {
      final Message_API message_api =
          Message_API.fromJson(json.decode(response.body));

      List<Message> messages = new List<Message>();
      message_api.result.forEach((element) {
        DateTime date_created = DateTime.parse(element.created);
        String str_date = DateFormat('dd.MM.yy kk:mm').format(date_created);
        messages.add(new Message(
            room: element.room,
            date_created: str_date,
            user: element.sender.username,
            text: element.text));
      });
      return messages.toList();
    } else {
      return Future.error('Не удалось соединиться с сервером');
    }
  }
}

// Модели JSON
class Room_API {
  List<Result> result;

  Room_API({this.result});

  Room_API.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String name;
  LastMessage lastMessage;

  Result({this.name, this.lastMessage});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage.toJson();
    }
    return data;
  }
}

class LastMessage {
  String room;
  String created;
  Sender sender;
  String text;

  LastMessage({this.room, this.created, this.sender, this.text});

  LastMessage.fromJson(Map<String, dynamic> json) {
    room = json['room'];
    created = json['created'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room'] = this.room;
    data['created'] = this.created;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['text'] = this.text;
    return data;
  }
}

class Sender {
  String username;

  Sender({this.username});

  Sender.fromJson(Map<String, dynamic> json) {
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    return data;
  }
}

class Message_API {
  List<Result_M> result;

  Message_API({this.result});

  Message_API.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Result_M>();
      json['result'].forEach((v) {
        result.add(new Result_M.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result_M {
  String room;
  String created;
  Sender sender;
  String text;

  Result_M({this.room, this.created, this.sender, this.text});

  Result_M.fromJson(Map<String, dynamic> json) {
    room = json['room'];
    created = json['created'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room'] = this.room;
    data['created'] = this.created;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['text'] = this.text;
    return data;
  }
}
