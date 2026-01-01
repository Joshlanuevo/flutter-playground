import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'my_custom_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.blue,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: const Center(
        child: MyCustomWidget(message: "Hello from custom widget!"),
      ),
    );
  }
}