import 'package:apknotif/services/controller_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: OutlinedButton(onPressed: (){ControllerPage().showNotification(id: 1 , title: 'Test Notification', body: 'Ceci est la toute première notification.');}, child: Text('Show Notification')),
      ),
    );
  }
}
