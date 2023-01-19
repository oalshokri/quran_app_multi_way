import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final surahCount = List.generate(114, (index) => index);
  List<dynamic> all = [];

  getData() async {
    String temp = await rootBundle.loadString('assets/hafs_smart_v8.json');
    all = jsonDecode(temp) as List;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: 114,
            itemBuilder: (context, index) {
              for (var item in all) {
                if (index + 1 == item['page']) {
                  print(all[index]['aya_text_emlaey']);
                }
              }
              return Text(
                (index + 1).toString(),
                style: TextStyle(fontSize: 24),
              );
            }),
      ),
    );
  }
}
