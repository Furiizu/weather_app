import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/modelJson.dart';
import 'package:weather_app/modelWeather.dart';


class Api{

  final String url = 'api.openweathermap.org';
  final String forecast = 'data/2.5/forecast';
  final String appid = 'd05045f1ac6c84797111459ec0fe5287';
  static Map error;


  Future<ModelJson> forecasting(String zip, String id) async{
    Map<String,String> body = {
      "APPID": appid,
      "zip": zip+','+id,
      "units" : 'metric'
    };
    Map<String, String> headers = {
      "Content-type": "application/json"
    };

    var uri = Uri.http(url, forecast, body);
    final request = await http.get(uri, headers: headers);
    if(request.statusCode == 200){
      Map response = jsonDecode(request.body);
      List<ModelWeather> list = new List();
      for(Map x in response['list']){
        list.add(ModelWeather.fromMap(x));
      }
      ModelJson model = new ModelJson(response['city']['name'], list);
//      print (model.city);
      return model;
    } else {
      Map response = jsonDecode(request.body);
      error = response;
      return null;
    }

  }


}