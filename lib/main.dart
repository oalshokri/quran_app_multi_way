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
    print(result);
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
      body: Center(
        child: !isLoaded
            ? CircularProgressIndicator()
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Text(
                              '${data[index]['text']} ${data[index]['numberInSurah']} ',
                              style: TextStyle(fontSize: 24),
                              textDirection: TextDirection.rtl,
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            currentPage++;
                            getData();
                          },
                          child: Text('next'),
                        ),
                        TextButton(
                          onPressed: () {
                            currentPage--;
                            getData();
                          },
                          child: Text('previous'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
