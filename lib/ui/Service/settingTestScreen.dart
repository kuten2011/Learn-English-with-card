import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingTestScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingTestScreen> {
  bool _useVietnamese = false;
  bool _shuffleQuestions = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useVietnamese = prefs.getBool('useVietnamese') ?? false;
      _shuffleQuestions = prefs.getBool('shuffleQuestions') ?? false;
    });
  }

  Future<void> _toggleLanguage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useVietnamese = value;
      prefs.setBool('useVietnamese', _useVietnamese);
    });
  }

  Future<void> _toggleShuffle(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shuffleQuestions = value;
      prefs.setBool('shuffleQuestions', _shuffleQuestions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dùng tiếng việt làm câu hỏi'),
              value: _useVietnamese,
              activeColor: Color(0xFF4254FE),
              contentPadding: const EdgeInsets.all(8.0),
              onChanged: _toggleLanguage,
            ),
            SwitchListTile(
              title: Text('Xáo trộn câu hỏi'),
              activeColor: Color(0xFF4254FE),
              contentPadding: const EdgeInsets.all(8.0),
              value: _shuffleQuestions,
              onChanged: _toggleShuffle,
            ),
          ],
        ),
      ),
    );
  }
}
