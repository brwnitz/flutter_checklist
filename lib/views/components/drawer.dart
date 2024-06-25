import 'package:checklist_master/views/config.dart';
import 'package:checklist_master/views/topic_list.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TopicList()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfigWidget()));
            },
          ),
        ],
      ),
    );
  }
}