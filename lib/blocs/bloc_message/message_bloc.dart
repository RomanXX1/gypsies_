import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_message/message_event.dart';
import 'package:gypsies/blocs/bloc_message/message_list_state.dart';
import 'package:gypsies/blocs/repository.dart';
import 'package:gypsies/models/message.dart';

class MessageBloc extends Bloc<MessageEvent, MessageListState> {
  final ObjRepository objRepository;
  final String room;
  MessageBloc({this.objRepository, this.room}) : assert(objRepository != null);

  @override
  MessageListState get initialState => MessageLoadingState();

  @override
  Stream<MessageListState> mapEventToState(MessageEvent event) async* {
    if (event is MessageLoadEvent) {
      yield MessageLoadingState();
      try {
        final List<Message> _loadedMessagesList =
            await objRepository.getMessages(room);
        yield MessageLoadedState(loadedMessages: _loadedMessagesList);
      } catch (_) {
        yield MessageErrorState();
      }
    }
  }
}
