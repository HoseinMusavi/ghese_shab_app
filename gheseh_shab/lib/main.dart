import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/app.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/data/repositories/login_repository.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/logic/login/login_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/presentation/widgets/story_form.dart';
import 'package:gheseh_shab/utils/theme.dart';

void main() {
  final storyRepository = Story_Repository();
  final dio = Dio(); // ایجاد نمونه Dio برای LoginRepository
  final loginRepository = LoginRepository(dio); // ایجاد LoginRepository

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StoryBloc(storyRepository)..add(FetchStoriesEvent()),
        ),
        BlocProvider(
          create: (context) =>
              LoginBloc(loginRepository), // اضافه کردن LoginBloc
        ),
      ],
      child: MyApp(homeRepository: storyRepository),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Story_Repository homeRepository;

  MyApp({required this.homeRepository});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('fa'), // تنظیم زبان به فارسی
      themeMode: _themeMode,
      theme: AppThemes.lightTheme, // استفاده از تم لایت
      darkTheme: AppThemes.darkTheme, // استفاده از تم دارک
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // راست‌چین کردن کل اپلیکیشن
          child: child!,
        );
      },
      home: GhesehShabApp(setThemeMode: setThemeMode), // تنظیم صفحه شروع
    );
  }
}
