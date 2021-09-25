import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:mobilef2/models/module_value.dart';
import 'package:mobilef2/style/color_constants.dart';
import 'package:mobilef2/arch/converter.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class RadarItemModel {
  RadarItemModel(this.topic, this.value);
  final String topic;
  final int value;
}

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
    required this.phone,
  }) : super(key: key);

  final String phone;

  var location = Location();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 3;

  @override
  Widget build(BuildContext context) {
    _listenLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваша оценка'),
        // automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<MainScreenFutureModel>(
        future: _fetchFetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildMainWidget(snapshot.data!.moduleValues);
          }
          return const Center(child: Text('Загрузка'));
        },
      ),
    );
  }

  SingleChildScrollView _buildMainWidget(List<ModuleValue> values) {
    int summ = 0;
    for (var element in values) {
      summ += element.sum;
    }
    List<Widget> widgets = [];
    widgets += _buildGeneralSection(summ);
    widgets += _buildRadarSection([
      RadarItemModel('proger', 40),
      RadarItemModel('logerуууууу', 20),
      RadarItemModel('anal', 70),
      RadarItemModel('rotуууу', 30),
    ]);

    widgets += [const Padding(padding: EdgeInsets.only(bottom: 32))];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  Future _listenLocation() async {
    var serviceEnabled = await widget.location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await widget.location.requestService();
    }

    var permissionGranted = await widget.location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await widget.location.requestPermission();
    }
    widget.location.onLocationChanged.listen((event) {
      print(event);
    });
    final loc = await widget.location.getLocation();
    return;
  }

  Future<MainScreenFutureModel> _fetchFetch() async {
    final modulesRespose = await http
        .get(Uri.parse('http://api-digit.siberian-hub.ru/v1/statistics/${widget.phone}/module/'));

    print('lksjdfsdffffff');
    print(modulesRespose.body);

    List<ModuleValue> modules = (utf8JsonConverte(modulesRespose.bodyBytes) as List)
        .map((e) => ModuleValue.fromJson(e))
        .toList();

    return MainScreenFutureModel(modules);
  }

  List<Widget> _buildGeneralSection(int generalCount) {
    final mapping = [
      '😵',
      '🤮',
      '🤕',
      '😰',
      '☹️',
      '😐',
      '🙂',
      '😌',
      '😄',
      '🤩',
    ];

    final String emoji;
    if (generalCount < 10) {
      emoji = '😵';
    } else if (generalCount < 20) {
      emoji = '🤮';
    } else if (generalCount < 30) {
      emoji = '🤕';
    } else if (generalCount < 40) {
      emoji = '😰';
    } else if (generalCount < 50) {
      emoji = '☹️';
    } else if (generalCount < 60) {
      emoji = '😐';
    } else if (generalCount < 70) {
      emoji = '🙂';
    } else if (generalCount < 80) {
      emoji = '😌';
    } else if (generalCount < 90) {
      emoji = '😄';
    } else {
      emoji = '🤩';
    }

    return [
      _buildTitle('Общая оценка:'),
      Center(
        child: Text('$generalCount',
            style: const TextStyle(fontSize: 30, color: ColorConstants.primaryColor)),
      ),
      Center(
        child: Text(emoji, style: TextStyle(fontSize: 100)),
      ),
    ];
  }

  List<Widget> _buildRadarSection(List<RadarItemModel> items) {
    final width = MediaQuery.of(context).size.width;
    return [
      _buildTitle('Диаграмма активности:'),
      Container(
        width: width,
        height: width,
        child: RadarChart(
          ticks: const [10, 50, 100],
          features: items.map((e) => e.topic.substring(0, 2) + '.').toList(),
          data: [items.map((e) => e.value).toList()],
          reverseAxis: false,
          sides: items.length,
          axisColor: Colors.grey,
          outlineColor: Colors.grey,
          graphColors: const [ColorConstants.secondaryColor],
        ),
      ),
      _buildDescriptionRadar(items),
    ];
  }

  Widget _buildTitle(String title) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 22, color: ColorConstants.secondaryColor),
        ),
      );

  Widget _buildDescriptionRadar(List<RadarItemModel> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: ColorConstants.backgroundGray,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            <Widget>[const Text('Пояснение:', style: TextStyle(fontWeight: FontWeight.w600))] +
                items
                    .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text('${e.topic.substring(0, 2) + '.'} - ${e.topic}'),
                        ))
                    .toList(),
      ),
    );
  }
}

class MainScreenFutureModel {
  MainScreenFutureModel(this.moduleValues);

  final List<ModuleValue> moduleValues;
}
