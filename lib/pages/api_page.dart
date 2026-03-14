import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apknotif/services/controller_page.dart';
import 'package:flutter/material.dart';


class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {

  List<dynamic> lessons = [];
  bool isLoading = true;
  final _controller = ControllerPage();
  Timer ? _timer;
  dynamic _lastNotificationLessons;

  @override
  void initState() {
    super.initState();
    fetchLessons();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchLessons();
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchLessons() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.69:8000/courses/')); {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted) {
            setState(() {
              lessons = data;
              isLoading = false;
            });
          }
          if (data.isNotEmpty) {
            final latestLesson = data.last;
            if (_lastNotificationLessons == null || latestLesson['id'] != _lastNotificationLessons['id']) {
               await _controller.showNotification(
                id: latestLesson['id'],
                title: latestLesson['title'],
                body: latestLesson['description'],
              );
              _lastNotificationLessons = latestLesson;
            }
          }
        } else {
          print('Erreur lors de la récupération des leçons : ${response.statusCode}');
        }
      };
    } catch (e) {
      print('Erreur lors de la récupération des leçons : $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications app"), backgroundColor: const Color.fromARGB(255, 224, 173, 155),),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          :lessons.isEmpty
              ? const Center(child: Text('Aucune leçon disponible.'))
          : ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return ListTile(
                  title: Text(lesson['title']),
                  subtitle: Text(lesson['description']),
                );
              },
             )
        ,
    );
  }
}