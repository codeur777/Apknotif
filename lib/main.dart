import 'package:apknotif/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:apknotif/services/controller_page.dart';
import 'package:apknotif/pages/api_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ControllerPage().initailize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test notif ',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ApiPage(),
    );
  }
}
