import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/auth_ui/welcomeScreen.dart';
import 'package:midtermm/ui/auth_ui/ChangePasswordScreen.dart';

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

  @override
  void initState() {
    super.initState();
    getUser();
    getTermsFromFirestore();
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
        backgroundColor: Colors.blueAccent,
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
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.blueAccent),
                    title: const Text('Change Password'),
                    onTap: () {
                      changePassword();
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.download_rounded, color: Colors.blueAccent),
                    title: const Text('Download Courses for Offline'),
                    subtitle: const Text(
                      'Your 8 most recently accessed courses will be automatically downloaded',
                    ),
                    onTap: () {
                      // Navigate to offline learning screen
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.storage, color: Colors.blueAccent),
                    title: const Text('Manage Storage'),
                    onTap: () {
                      // Navigate to storage management screen
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: Colors.blueAccent,
                    contentPadding: const EdgeInsets.all(8.0),
                    title: const Text('Push Notifications'),
                    value: false,
                    onChanged: (bool value) {
                      // Handle push notification toggle
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: Colors.blueAccent,
                    contentPadding: const EdgeInsets.all(8.0),
                    title: const Text('Sound Effects'),
                    value: true,
                    onChanged: (bool value) {
                      // Handle sound effects toggle
                    },
                  ),
                  const Divider(),
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
