import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patterns_app/coord_event.dart';
import 'package:patterns_app/coord_model.dart';
import 'package:patterns_app/coord_state.dart';

import 'fake_server.dart';

class CoordBloc extends Bloc<int, CoordState> {
  FakeServer _server = FakeServer();
  CoordState currentState = CoordInitState();

  CoordBloc(CoordState initialState) : super(initialState);

  @override
  Stream<CoordState> mapEventToState(int event) async* {
    print('Got Event!');
    if (event == CoordEvent.EVENT_REFRESH) {
      requestData();
      yield CoordLoadingState();
    }
    yield currentState;
  }

  requestData() async {
    String response = await _server.getWeather();
    try {
      print(response);
      WeatherModel model = WeatherModel.fromJson(jsonDecode(response));
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        currentState = CoordLoadSuccessState(model);
      } else {
        currentState = CoordLoadErrorState();
      }
    } catch (e) {
      currentState = CoordLoadErrorState();
    }

    this.add(CoordEvent.EVENT_LOADED);
  }
}