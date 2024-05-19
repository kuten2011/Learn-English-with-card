import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPracticeScreen extends StatefulWidget {
  @override
  _SettingPracticeScreenState createState() => _SettingPracticeScreenState();
}

class _SettingPracticeScreenState extends State<SettingPracticeScreen> {
  bool _shuffleQuestions = false;
  bool _useVietnamese = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shuffleQuestions = prefs.getBool('shufflePracticeQuestions') ?? false;
      _useVietnamese = prefs.getBool('useVietnamesePractice') ?? false;
    });
  }

  Future<void> _toggleShuffle(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _shuffleQuestions = value;
      prefs.setBool('shufflePracticeQuestions', _shuffleQuestions);
    });
  }

  Future<void> _toggleLanguage(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _useVietnamese = value;
      prefs.setBool('useVietnamesePractice', _useVietnamese);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dùng tiếng việt làm câu hỏi'),
              activeColor: Color(0xFF4254FE),
              contentPadding: const EdgeInsets.all(8.0),
              value: _useVietnamese,
              onChanged: _toggleLanguage,
            ),
            SwitchListTile(
              title: Text('Xóa trộn câu hỏi'),
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
