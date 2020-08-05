import 'coord_model.dart';

abstract class CoordState {}

class CoordLoadingState extends CoordState {}

class CoordLoadSuccessState extends CoordState {
  WeatherModel coordModel;
  CoordLoadSuccessState(this.coordModel);
}

class CoordLoadErrorState extends CoordState {
}

class CoordInitState extends CoordState {}
