import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/auth_ui/welcomeScreen.dart';
import 'package:midtermm/ui/auth_ui/ChangePasswordScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  State<settingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<settingScreen> {
  late User? user;
  late String userEmail = 'No Email';
  String userName = 'No Username';
  bool isLoading = true;
  bool soundEffects = true;
  bool notification = true;

  @override
  void initState() {
    super.initState();
    getUser();
    getTermsFromFirestore();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEffects = prefs.getBool('soundEffect') ?? false;
    });
  }

  Future<void> _toggleNofication(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notification = value;
      prefs.setBool('nofication', notification);
    });
  }

  Future<void> _toggleSound(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEffects = value;
      prefs.setBool('soundEffect', soundEffects);
    });
  }

  void getUser() {
    user = FirebaseAuth.instance.currentUser;
    userEmail = user?.email ?? 'No Email';
  }

  Future<void> getTermsFromFirestore() async {
    if (userEmail == 'No Email') {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final QuerySnapshot querySnapshot = await usersCollection
        .where('userEmail', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot userDoc = querySnapshot.docs.first;
      setState(() {
        userName = userDoc['userName'] ?? 'No Username';
      });
    } else {
      setState(() {
        userName = 'No Username Found';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
        backgroundColor: Color(0xFF4254FE),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      userEmail,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '',
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Color(0xFF4254FE),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF4254FE),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      elevation: 0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.lock, color: Color(0xFF4254FE)),
                            title: const Text('Change Password'),
                            onTap: () {
                              changePassword();
                            },
                          ),
                          buildDividerWithPadding(),
                          ListTile(
                            leading: Icon(Icons.download_rounded, color: Color(0xFF4254FE)),
                            title: const Text('Download Courses for Offline'),
                            subtitle: const Text(
                              'Your 8 most recently accessed courses will be automatically downloaded',
                            ),
                            onTap: () {
                              // Navigate to offline learning screen
                            },
                          ),
                          buildDividerWithPadding(),
                          ListTile(
                            leading: Icon(Icons.storage, color: Color(0xFF4254FE)),
                            title: const Text('Manage Storage'),
                            onTap: () {
                              // Navigate to storage management screen
                            },
                          ),
                          buildDividerWithPadding(),
                          SwitchListTile(
                            activeColor: Color(0xFF4254FE),
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: const Text('Push Notifications'),
                            ),
                            value: notification,
                            onChanged: _toggleNofication,
                          ),
                          buildDividerWithPadding(),
                          SwitchListTile(
                            activeColor: Color(0xFF4254FE),
                            contentPadding: const EdgeInsets.all(8.0),
                            title: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: const Text('Sound Effects'),
                            ),
                            value: soundEffects,
                            onChanged: _toggleSound,
                          ),
                          buildDividerWithPadding(),
                          ListTile(
                            leading: Icon(Icons.logout, color: Colors.redAccent),
                            title: const Text('Logout'),
                            onTap: () {
                              signOut();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDividerWithPadding() {
    return Row(
      children: [
        SizedBox(width: 55), // adjust the width as needed
        Expanded(child: Divider()),
      ],
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const welcomeScreen()),
      (route) => false,
    );
  }

  void changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
    );
  }
}
