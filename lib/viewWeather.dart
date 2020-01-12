import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/modelJson.dart';

class ViewWeather extends StatefulWidget {
  final String nama;
  final ModelJson model;

  const ViewWeather({Key key, this.nama, this.model}) : super(key: key);

  State<StatefulWidget> createState() => _ViewWeatherState();
}

class _ViewWeatherState extends State<ViewWeather> {
  ScrollController _scrollController;
  String waktu = '';
  String top = '';
  Text title;
  int days = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() => _isAppBarExpanded
          ? setState(
              () {
                title = Text(
                  'Selamat $waktu \n${widget.nama.toUpperCase()}',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                );
              },
            )
          : setState(() {
              title = Text(
                'Forecast Kota ${widget.model.city}',
              );
              top = 'Forecast Kota ${widget.model.city}';
            }));
  }

  Widget listWeather(int day) {
    return ListTile(
      title: Text(
        DateFormat('dd MMMM yyyy')
            .format(DateTime.now().add(Duration(days: day))),
      ),
      leading: Tab(
        icon: Container(
          child: Image.network('http://openweathermap.org/img/wn/'
              '${widget.model.weathers.where((x) => x.time.day == DateTime.now().add(Duration(days: day)).day).first.icon}'
              '@2x.png'),
        ),
      ),
      subtitle: Text('${widget.model.weathers.where((x) => x.time.day == DateTime.now().add(Duration(days: day)).day).first.weather}'),
      onTap: (){
        setState(() {
          days = day;
        });
      },
      selected: days == day,
    );
  }

  Widget weather(int day) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.model.weathers
            .where((x) =>
                x.time.day == DateTime.now().add(Duration(days: day)).day)
            .map((x) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: <Widget>[
                Text(x.time.hour.toString() + '.00'),
                Tab(
                  icon: Container(
                    child: Image.network(
                        'http://openweathermap.org/img/wn/${x.icon}@2x.png'),
                  ),
                ),
                Text(x.weather),
                Text(x.temp + '\u{2103}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  bool get _isAppBarExpanded {
    return _scrollController.offset <
        (MediaQuery.of(context).size.height / 4 - kToolbarHeight);
  }

  String namaWaktu(int jam) {
    String _waktu = '';
    if (jam > 3 && jam <= 9) {
      _waktu = 'Pagi';
    } else if (jam > 9 && jam < 15) {
      _waktu = 'Siang';
    } else if (jam >= 15 && jam <= 19) {
      _waktu = 'Sore';
    } else {
      _waktu = 'Malam';
    }
    return _waktu;
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    waktu = namaWaktu(time.hour);

    // TODO: implement build
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return <Widget>[
              SliverAppBar(
                  elevation: 12,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height / 4,
                  flexibleSpace: FlexibleSpaceBar(
                    title: title,
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background:
                        Image.asset('assets/cloud.jpg', fit: BoxFit.fill),
                  ))
            ];
          },
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        DateFormat('dd MMMM yyyy').format(DateTime.now().add(Duration(days: days))),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        widget.model.city,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Colors.grey[500],
                  elevation: 12,
                  child: Container(
//                        width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: weather(days),
                      ),
                    ),
                  ),
                ),
                Card(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      listWeather(0),
                      Divider(
                        thickness: 2,
                      ),
                      listWeather(1),
                      Divider(
                        thickness: 2,
                      ),
                      listWeather(2),
                      Divider(
                        thickness: 2,
                      ),
                      listWeather(3),
                      Divider(
                        thickness: 2,
                      ),
                      listWeather(4),
                      Divider(
                        thickness: 2,
                      ),
                      listWeather(5),
                    ],
                  ),
                ))
              ],
            )),
          )),
    );
  }
}
