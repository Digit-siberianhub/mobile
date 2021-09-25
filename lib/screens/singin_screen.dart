import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobilef2/models/module.dart';
import 'package:mobilef2/widget/selection_item.dart';
import 'package:mobilef2/style/color_constants.dart';
import 'package:mobilef2/arch/iterable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:mobilef2/arch/converter.dart';

import 'package:http/http.dart' as http;

import 'main_scree.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String fio = '';
  String phone = '';
  String profession = '';

  List<String> moduleNames = [];
  List<String> moduleValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<SigninScreenFutureModel>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildMainWidget(
                context,
                snapshot.data!.professions,
                snapshot.data!.moduleNames,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<SigninScreenFutureModel> _fetchData() async {
    await Future.delayed(const Duration(seconds: 1));

    final modulesRespose =
        await http.get(Uri.parse('https://api-digit.siberian-hub.ru/v1/module/'));
    final profTypesResopnse =
        await http.get(Uri.parse('https://api-digit.siberian-hub.ru/v1/user/types/'));

    List<Module> modules = (utf8JsonConverte(modulesRespose.bodyBytes) as List)
        .map((e) => Module.fromJson(e))
        .toList();
    List<String> profTypes = (utf8JsonConverte(profTypesResopnse.bodyBytes) as List)
        .map((e) => e['name'] as String)
        .toList();

    final fetchedProfessions = profTypes;
    final fetchedModules = modules.map((e) => e.name).toList();

    return SigninScreenFutureModel(fetchedProfessions, fetchedModules);
  }

  Future<bool> _sendData(
    String fio,
    String phone,
    String profession,
    List<String> moduleNames,
    List<String> moduleValues,
    BuildContext context,
  ) async {
    List<Map<String, String>> modules = [];
    for (int i = 0; i < moduleNames.length; i++) {
      modules.add({
        'name': moduleNames[i],
        'username': moduleValues[i],
      });
    }

    final response = await http.post(
      Uri.parse('https://api-digit.siberian-hub.ru/v1/user/auth/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'fio': fio,
        'phone': phone,
        'type': profession,
        'modules': modules,
      }),
    );

    print(response.body);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  phone: phone,
                )));

    return response.statusCode == 201;
  }

  SingleChildScrollView _buildMainWidget(
      BuildContext context, List<String> professions, List<String> moduleNames_) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                const Text(
                  'Введите данные',
                  style: TextStyle(
                    fontSize: 30,
                    color: ColorConstants.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 24)),
              ] +
              _buildAboutYouSection() +
              [const Padding(padding: EdgeInsets.only(top: 24))] +
              _buildProfessionsSection(professions) +
              [const Padding(padding: EdgeInsets.only(top: 24))] +
              _buildModulesSection(moduleNames_) +
              [
                const Padding(padding: EdgeInsets.only(top: 32)),
                _buildSignInButton(context),
              ],
        ),
      ),
    );
  }

  List<Widget> _buildProfessionsSection(List<String> professions) {
    return _buildSection('Ваша профессия', [
      GestureDetector(
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (subContext) {
                return Container(
                  height: 300,
                  child: Column(
                    children: professions
                        .map((e) => SelectionItem(
                            title: e,
                            onSelect: (text) {
                              setState(() {
                                profession = text;
                                Navigator.of(subContext).pop();
                              });
                            }))
                        .toList(),
                  ),
                );
              },
            );
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorConstants.primaryColor,
                width: 2,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      profession,
                      style: const TextStyle(
                        color: ColorConstants.primaryColor,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_drop_down, size: 30),
                ),
              ],
            ),
          ))
    ]);
  }

  Widget _buildSignInButton(BuildContext context) => GestureDetector(
      onTap: () {
        singinAction(context);
      },
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
            color: ColorConstants.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child:
            const Center(child: Text('Войти', style: TextStyle(color: Colors.white, fontSize: 20))),
      ));

  List<Widget> _buildModulesSection(List<String> _moduleNames) {
    moduleNames = _moduleNames;
    if (moduleNames.length != moduleValues.length) {
      moduleValues = moduleNames.map((e) => "").toList();
    }
    return _buildSection(
        'Введите логины в модулях:',
        moduleNames
            .mapIndex(
              (element, index) => _buildTextField(element, (newText) {
                moduleValues[index] = newText;
              }),
            )
            .toList());
  }

  List<Widget> _buildAboutYouSection() => _buildSection(
        'Информация о вас:',
        [
          _buildTextField('ФИО', (newText) {
            fio = newText;
          }),
          _buildTextField('Телефон', (newText) {
            phone = newText;
          }),
        ],
      );

  List<Widget> _buildSection(String title, List<Widget> widgets) {
    return <Widget>[
          Text(
            title,
            style: const TextStyle(color: ColorConstants.primaryColor, fontSize: 20),
          ),
        ] +
        widgets.map((e) => Padding(padding: const EdgeInsets.only(top: 8), child: e)).toList();
  }

  TextField _buildTextField(String label, Function(String) onChange) => TextField(
        onChanged: onChange,
        style: const TextStyle(
          color: ColorConstants.primaryColor,
        ),
        cursorColor: ColorConstants.primaryColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: ColorConstants.primaryColor),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.primaryColor, width: 2.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.primaryColor, width: 2.0),
          ),
        ),
      );

  void singinAction(BuildContext context) {
    bool notEmpty = fio.isNotEmpty && phone.isNotEmpty && profession.isNotEmpty;
    moduleValues.forEach((element) {
      notEmpty = notEmpty && element.isNotEmpty;
      print(element);
    });

    print(fio);
    print(phone);
    print(profession);
    if (notEmpty) {
      _sendData(fio, phone, profession, moduleNames, moduleValues, context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Введите все данные'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class SigninScreenFutureModel {
  SigninScreenFutureModel(this.professions, this.moduleNames);

  final List<String> professions;
  final List<String> moduleNames;
}
