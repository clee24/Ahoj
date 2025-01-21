import 'package:flutter/cupertino.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AhojApp());
}

class AhojApp extends StatelessWidget {
  const AhojApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Ahoj',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
      ),
      home: HomeScreen(),
    );
  }
}
