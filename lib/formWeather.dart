import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/dropDownModel.dart';
import 'package:weather_app/viewWeather.dart';

import 'modelJson.dart';

class FormWeather extends StatefulWidget {
  State<StatefulWidget> createState() => _FormWeatherState();
}

class _FormWeatherState extends State<FormWeather> {
  final _formKey = new GlobalKey<FormState>();
  String nama;
  String kodePos;
  String value = 'us';
  List<DropDownModel> dropDownItem = [
    new DropDownModel('us', 'United State'),
    new DropDownModel('id', 'Indonesia'),
    new DropDownModel('uk', 'United Kingdom'),
  ];

  void dialogError(Map error){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error ${error['cod']}'),
            content:Text(
              error['message']+'\nUntuk mencoba gunakan negara United State dan kode pos 94040',
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                    'Oke'
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final idCountry = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.flag),
          labelText: "Negara",
        ),
        items: dropDownItem.map((x) {
          return DropdownMenuItem(
            value: x.value,
            child: Text(x.text),
          );
        }).toList(),
        value: value,
        onChanged: (values) {
          setState(() {
            value = values;
          });
        },
      ),
    );

    final inputNama = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? 'Nama harus diisi' : null,
        onSaved: (value) => nama = value,
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: "Nama Lengkap",
        ),
      ),
    );

    final inputKodePos = Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        validator: (value) => value.isEmpty ? 'Kode Pos harus diisi' : null,
        onSaved: (value) => kodePos = value,
        decoration: InputDecoration(
          icon: Icon(Icons.local_post_office),
          labelText: "KodePos",
        ),
      ),
    );

    final checkWeather = Container(
      padding: EdgeInsets.all(8),
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        icon: Icon(FontAwesomeIcons.cloudSun),
        label: Text(
          "Forecast Cuaca",
          style: TextStyle(fontSize: 20),
        ),
        textColor: Theme.of(context).accentTextTheme.title.color,
        color: Theme.of(context).accentColor,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            ModelJson model = await Api().forecasting(kodePos, value);
            if (model != null){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewWeather(
                      nama: nama,
                      model: model,
                    ),
                  )
              );
            } else {
              dialogError(Api.error);
            }
          }
//          print(DateTime.fromMillisecondsSinceEpoch(1578819600));
//          print(await Api().forecasting('94040'));
        },
      ),
    );

    final form = Container(
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            inputNama,
            idCountry,
            inputKodePos,
            checkWeather,
          ],
        ),
      ),
    );

    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Forecast Cuaca App'),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            child: form,
          ),
        ));
  }
}
