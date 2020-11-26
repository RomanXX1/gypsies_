import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gypsies/blocs/bloc_room/room_event.dart';
import 'package:gypsies/blocs/bloc_room/room_list_state.dart';
import 'package:gypsies/blocs/repository.dart';
import 'package:gypsies/models/room.dart';

class RoomBloc extends Bloc<RoomEvent, RoomListState> {
  final ObjRepository objRepository;
  RoomBloc({this.objRepository}) : assert(objRepository != null);

  @override
  RoomListState get initialState => RoomsStartPage();

  @override
  Stream<RoomListState> mapEventToState(RoomEvent event) async* {
    if (event is RoomLoadEvent) {
      yield RoomsLoadingState();
      try {
        final List<Room> _loadedRoomsList = await objRepository.getRooms();
        yield RoomsLoadedState(loadedRoom: _loadedRoomsList);
      } catch (_) {
        yield RoomsErrorState();
      }
    }
  }
}
