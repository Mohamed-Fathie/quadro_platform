import 'package:flutter/material.dart';
import 'package:quadro_platform/theme/globalthemdata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalThemData.lightThemeData,
      darkTheme: GlobalThemData.darkThemeData,
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("qadro app"),
        ),
        body: const Center(
          child: Text("hi!!"),
        ),
      ),
    );
  }
}
