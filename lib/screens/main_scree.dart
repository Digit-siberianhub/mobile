import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:mobilef2/style/color_constants.dart';
import 'package:mobilef2/arch/converter.dart';

class RadarItemModel {
  RadarItemModel(this.topic, this.value);
  final String topic;
  final int value;
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool darkMode = false;
  bool useSides = false;
  double numberOfFeatures = 3;

  @override
  Widget build(BuildContext context) {
    const ticks = [10, 50, 100];

    List<Widget> widgets = [];
    widgets += _buildGeneralSection(90);
    widgets += _buildRadarSection([
      RadarItemModel('proger', 40),
      RadarItemModel('logerуууууу', 20),
      RadarItemModel('anal', 70),
      RadarItemModel('rotуууу', 30),
    ]);

    widgets += [const Padding(padding: EdgeInsets.only(bottom: 32))];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваша оценка'),
        // automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: widgets,
        ),
      ),
    );
  }

  List<Widget> _buildGeneralSection(int generalCount) {
    return [
      _buildTitle('Общая оценка:'),
      Center(
        child: Text('$generalCount',
            style: const TextStyle(fontSize: 30, color: ColorConstants.primaryColor)),
      ),
      const Center(
        child: Text('😀', style: TextStyle(fontSize: 100)),
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
