import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

const bestProduct = "https://dummyjson.com/products";
Future<String> product() async {
  final http.Response response = await http.get(Uri.parse(bestProduct));
  if (response.statusCode == 200) {
    final String data = response.body;
    final Map<String, dynamic> decodedJson = jsonDecode(data);
    final String bestProducts =
        decodedJson["products"][0]["tags"][2].toString();
    return bestProducts;
  } else {
    return Future.error("Error");
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<String>? produktList;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "API Produkt Test",
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: FutureBuilder<String>(
                  future: produktList,
                  builder: (context, snapshot) {
                    String productList = "";
                    if (snapshot.hasError) {
                      productList =
                          "Es ist ein Fehler aufgetreten : ${snapshot.error}";
                      return Text(productList);
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      productList = snapshot.data!;
                      return Text(productList,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold));
                    }
                    return const Text("Noch keine Daten vorhanden");
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    produktList = product();
                  });
                },
                child: const Text("Press Button"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
