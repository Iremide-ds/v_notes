import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:json_theme/json_theme.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lightThemeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final darkThemeStr = await rootBundle.loadString('assets/appainter_theme_dark.json');

  final lightThemeJson = jsonDecode(lightThemeStr);
  final darkThemeJson = jsonDecode(darkThemeStr);

  final lightTheme = ThemeDecoder.decodeThemeData(lightThemeJson);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson);

  runApp(ProviderScope(
      child: MyApp(
    darkTheme: darkTheme!,
    lightTheme: lightTheme!,
  )));
}

class MyApp extends StatelessWidget {
  final ThemeData lightTheme, darkTheme;

  const MyApp({
    super.key,
    required this.lightTheme,
    required this.darkTheme,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
        title: 'V Notes',
        themeAnimationCurve: Curves.easeIn,
        theme: lightTheme,
        darkTheme: darkTheme,
        routes: Routes.routes,
        onGenerateRoute: Routes.onGenerateRoute,
      );
      },
    );
  }
}
