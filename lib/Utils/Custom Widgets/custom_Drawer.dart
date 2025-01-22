import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:MedTime/Utils/Api/View/topicsListPage.dart';
import 'package:MedTime/Views/UserPages/userProfilePage.dart';
import 'package:MedTime/Views/medicineHistoryPage.dart';

import '../Helper Functions/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final Function()? onHomePressed;
  final Function()? onHistoryPressed;
  final Function()? onTipsPressed;
  final Function()? onSettingsPressed;
  final Function()? onProfilePressed;

  const CustomDrawer({
    super.key,
    this.onHomePressed,
    this.onHistoryPressed,
    this.onTipsPressed,
    this.onSettingsPressed,
    this.onProfilePressed,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? _userName;
  String? _userPhoto;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName');
      _userPhoto = prefs.getString('userPhoto');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName ?? "Guest",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: getImageProvider(_userPhoto),
              child: _userPhoto == null || _userPhoto!.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    )
                  : null,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: widget.onHomePressed,
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Medicine History'),
            onTap: widget.onHistoryPressed,
          ),
          ListTile(
            leading: const Icon(Icons.tips_and_updates),
            title: const Text('Medical Tips'),
            onTap: widget.onTipsPressed,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: widget.onSettingsPressed,
          ),
        ],
      ),
    );
  }
}
