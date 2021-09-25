import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mobilef2/style/color_constants.dart';
import 'package:mobilef2/arch/iterable.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String fio = '';
  String phone = '';

  List<String> moduleNames = [];
  List<String> moduleValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    const Text('Введите данные',
                        style: TextStyle(
                            fontSize: 30,
                            color: ColorConstants.primaryColor,
                            fontWeight: FontWeight.w700)),
                    const Padding(padding: EdgeInsets.only(bottom: 24)),
                  ] +
                  _buildAboutYouSection() +
                  [const Padding(padding: EdgeInsets.only(top: 24))] +
                  _buildModulesSection(['vk', 'telegram', 'gmail']) +
                  [
                    const Padding(padding: EdgeInsets.only(top: 24)),
                    _buildSignInButton(context),
                  ],
            ),
          ),
        ),
      ),
    );
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
    moduleValues = moduleNames.map((e) => "").toList();
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
    print(fio);
    print(phone);
    print(moduleValues);
    // showMaterialSelectionPicker<String>(
    //     context: context,
    //     title: 'Pick Your State',
    //     items: ['fine1', 'fine2'],
    //     selectedItem: 'fine1');
  }
}
