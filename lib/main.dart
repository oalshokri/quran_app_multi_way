import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
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
  int currentPage = 1;
  bool isLoaded = false;
  dynamic data;

  List<Text> all = [];

  void getData() async {
    http.Response response = await http.get(
      Uri.parse('http://api.alquran.cloud/v1/page/$currentPage/quran-uthmani'),
    );

    var result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isLoaded = true;
        data = result['data']['ayahs'] as List;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoaded
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: '',
                    style: TextStyle(color: Colors.black, fontSize: 21),
                    // recognizer: LongPressGestureRecognizer()
                    //   ..onLongPress=(){},
                    children: [
                      for (var item in data) ...{
                        TextSpan(
                          text: '${item['text']} ',
                        ),
                        WidgetSpan(
                            child: Container(
                          color: Colors.red,
                          child: Text('${item['numberInSurah']} '),
                        ))
                      }
                    ]),
              ),
            ),
    );
  }
}
