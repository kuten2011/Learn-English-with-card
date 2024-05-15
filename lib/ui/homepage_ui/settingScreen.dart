import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:midtermm/ui/auth_ui/welcomeScreen.dart';

class settingScreen extends StatefulWidget {
  const settingScreen({Key? key}) : super(key: key);

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
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
        title: const Text('Cài đặt'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    userName,
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: const TextStyle(color: Colors.black),
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    title: const Text('Lưu học phần để học ngoại tuyến'),
                    subtitle: const Text(
                      '8 học phần mới học gần đây nhất của bạn sẽ được tự động tải xuống',
                    ),
                    trailing: const Icon(Icons.download_rounded),
                    onTap: () {
                      // Navigate to offline learning screen
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    title: const Text('Quản lý dung lượng lưu trữ'),
                    trailing: const Icon(Icons.storage),
                    onTap: () {
                      // Navigate to storage management screen
                    },
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Thông báo đẩy'),
                  value: false,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF4254FE),
                  inactiveTrackColor: const Color.fromARGB(255, 178, 178, 178),
                  inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                  onChanged: (bool value) {
                    // Handle push notification toggle
                  },
                ),
                SwitchListTile(
                  title: const Text('Hiệu ứng âm thanh'),
                  value: true,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF4254FE),
                  inactiveTrackColor: const Color.fromARGB(255, 178, 178, 178),
                  inactiveThumbColor: const Color.fromARGB(255, 255, 255, 255),
                  onChanged: (bool value) {
                    // Handle push notification toggle
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListTile(
                    title: const Text('Đăng xuất'),
                    trailing: const Icon(Icons.logout),
                    onTap: () {
                      signOut();
                    },
                  ),
                ),
              ],
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
}
