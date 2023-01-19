import 'dart:convert';

import 'package:flutter/gestures.dart';
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
  bool isLoading = false;
  dynamic data;

  List<Text> all = [];

  void getData() async {
    http.Response response = await http.get(
      Uri.parse('http://api.alquran.cloud/v1/page/$currentPage/quran-uthmani'),
    );

    var result = jsonDecode(response.body);
    print(result);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
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
      body: Center(
        child: !isLoading
            ? CircularProgressIndicator()
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '',
                      style: TextStyle(color: Colors.black),
                      children: [
                        for (var item in data) ...{
                          TextSpan(
                              text: '${item['text']}',
                              style: TextStyle(fontSize: 24, height: 1.5),
                              recognizer: DoubleTapGestureRecognizer()
                                ..onDoubleTap = () {
                                  print('navigate to signup screen');
                                }),
                          WidgetSpan(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/end.png'),
                                ),
                              ),
                              child: Text(
                                '${item['numberInSurah']}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        }
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
