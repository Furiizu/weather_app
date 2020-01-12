
import 'package:intl/intl.dart';

class ModelWeather{
  String weather;
  String icon;
  DateTime time;
  String temp;

  ModelWeather.fromMap(Map map){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    this.weather = map['weather'][0]['main'];
    this.icon = map['weather'][0]['icon'];
    this.time = dateFormat.parse(map['dt_txt']);
    this.temp = map['main']['feels_like'].toString();

  }

}