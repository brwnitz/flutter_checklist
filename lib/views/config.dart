import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigWidget extends StatefulWidget {
  const ConfigWidget({super.key});

  @override
  ConfigWidgetState createState() => ConfigWidgetState();
}

class ConfigWidgetState extends State<ConfigWidget> {
  final TextEditingController _dropdownController = TextEditingController();
  final TextEditingController _darkFieldController = TextEditingController();
  SharedPreferences? prefs;

  @override
  void dispose() {
    _dropdownController.dispose();
    _darkFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setControllers();
    
  }

  void setControllers() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _dropdownController.text = prefs!.getInt('weeks') == 1 ? '1' : prefs!.getInt('weeks') == 2 ? '2' : '3';
      _darkFieldController.text = prefs!.getInt('darkMode') == 0 ? '0' : '1';
    });
  }



  @override
  Widget build(BuildContext   context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Widget Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _dropdownController.text == '' ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
              value: _dropdownController.text,
              onChanged: (newValue) {
                setState(() {
                  _dropdownController.text = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: '1',
                  child: Text('Option 1'),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Text('Option 2'),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Text('Option 3'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Select',
              ),
            ),
            const SizedBox(height: 16.0),
            _darkFieldController.text == '' ? const CircularProgressIndicator()
            : DropdownButtonFormField<String>(
              value: _darkFieldController.text,
              onChanged: (newValue) {
                setState(() {
                  _darkFieldController.text = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: '0',
                  child: Text('Tema escuro'),
                ),
                DropdownMenuItem(
                  value: '1',
                  child: Text('Tema claro'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Select',
              ),
            ),
            TextButton(
              onPressed: (){
              prefs!.setInt('weeks', _dropdownController.text == '1' ? 1 : _dropdownController.text == '2' ? 2 : 3);
              prefs!.setInt('darkMode', _darkFieldController.text == '0' ? 0 : 1);
              Navigator.pop(context);
              },
             child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}