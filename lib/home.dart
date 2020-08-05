import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patterns_app/coord_bloc.dart';
import 'package:patterns_app/coord_event.dart';
import 'package:patterns_app/coord_state.dart';

import 'coord_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoordBloc, CoordState>(
      builder: (BuildContext context, state) {
        print(state.toString());
        if (state is CoordInitState) {
          BlocProvider.of<CoordBloc>(context).add(CoordEvent.EVENT_REFRESH);
          return drawLoadingScreen();
        } else if (state is CoordLoadingState) {
          return drawLoadingScreen();
        } else if (state is CoordLoadErrorState) {
          return drawErrorScreen();
        } else if (state is CoordLoadSuccessState) {
          print('Got Success Event');
          CoordLoadSuccessState successState = state;
          return drawSuccessScreen();
        } else {
          return drawErrorScreen();
        }
      },
    );
  }

  drawSuccessScreen() {
    return Scaffold(
      body: SingleChildScrollView(
              child: Center(
            child:FutureBuilder<WeatherModel>(
                future: getData(),
                builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //checks if the response returns valid data
                  return Center(
                    child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Weather Application',
              style: TextStyle(color: Colors.blue, fontSize: 24),
            ),
                  Text(
                    'coord', style: TextStyle(
                       fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Text('Lat: '+ snapshot.data.coord.lat.toString(), style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey, 
                              ),),
                            
                             //displays the quote
                           SizedBox(
                              width: 50,
                            ),
                            Text('|', style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey, 
                            ),),
                            SizedBox(
                              width: 50,
                            ),
                            Text('Lng: ' + snapshot.data.coord.lon.toString() , style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey, 
                            ),),
                            ],
                          ),
                         SizedBox(
                          height: 30,
                        ),
                            Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                          'Main', style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        
                            
                        Text('Tempreture: ' + snapshot.data.main.temp.toString() , style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45, 
                        ),),
                        Text('Pressure: '+ snapshot.data.main.pressure.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45, 
                        ),),
                        Text('Humidity : '+  snapshot.data.main.humidity.toString() , style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45, 
                        ),),
                        Text('Highest tempreture: ' + snapshot.data.main.tempMax.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45, 
                        ),),
                        Text('Lowest tempreture:  ' + snapshot.data.main.tempMin.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45, 
                        ),),
                        SizedBox(
                          height: 30,
                        ),
                       
                        Text('Wind', style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Text('Speed: ' + snapshot.data.wind.speed.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        SizedBox(
                          width: 50,
                        ),
                        Text('|', style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        SizedBox(
                          width: 50,
                        ),
                        Text('degree: ' + snapshot.data.wind.deg.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        ],
                    ),
                    SizedBox(
                          height: 30,
                        ),
                     Text(
                  'Sys', style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Sunrise: ' + snapshot.data.sys.sunrise.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        SizedBox(
                          width: 50,
                        ),
                        Text('|', style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        SizedBox(
                          width: 30,
                        ),
                        Text('Sunset: ' + snapshot.data.sys.sunset.toString(), style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey, 
                        ),),
                        SizedBox(
                          height: 30,
                        ),
            
          ],
          
        ),
        _reloadButton()
        ])]));
                }}),
    ),
      )
    );
  }

  drawErrorScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[Text('Load Error'), _reloadButton()],
        ),
      ),
    );
  }

  drawLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[Text('Loading'), _reloadButton()],
        ),
      ),
    );
  }

  RaisedButton _reloadButton() {
    return RaisedButton(
      onPressed: () {
        BlocProvider.of<CoordBloc>(context).add(CoordEvent.EVENT_REFRESH);
      },
      child: Text('Reload'),
    );
  }
  Future<WeatherModel> getData() async {
    String url =
        'https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
