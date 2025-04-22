import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/app.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/data/repositories/category_repository.dart';
import 'package:gheseh_shab/data/repositories/coin_repository.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/data/repositories/user_repository.dart';
import 'package:gheseh_shab/logic/auth/login_bloc.dart';
import 'package:gheseh_shab/logic/auth/register/register_bloc.dart';
import 'package:gheseh_shab/logic/auth/reset_password_bloc.dart';
import 'package:gheseh_shab/logic/category/category_bloc.dart';
import 'package:gheseh_shab/logic/coin/coin_bloc.dart';
import 'package:gheseh_shab/logic/navigation/navigation_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/logic/user_info/user_bloc.dart';
import 'package:gheseh_shab/logic/user_info/user_event.dart';
import 'package:gheseh_shab/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark; // حالت پیش‌فرض تم دارک
  late ThemeData _currentTheme; // ذخیره مرجع تم

  // وابستگی‌ها
  late final Dio _dio;
  late final AuthRepository _authRepository;
  late final StoryRepository _storyRepository;
  late final CategoryRepository _categoryRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();

    // مقداردهی وابستگی‌ها
    _dio = Dio(BaseOptions(baseUrl: 'https://qesseyeshab.ir/api'));
    _authRepository = AuthRepository(dio: _dio);
    _storyRepository = StoryRepository(); // فقط یک بار مقداردهی شود
    _categoryRepository = CategoryRepository(dio: _dio);
    _userRepository =
        UserRepository(authRepository: _authRepository, dio: _dio);
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ذخیره مرجع تم فعلی
    _currentTheme = _themeMode == ThemeMode.dark
        ? AppThemes.darkTheme
        : AppThemes.lightTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(_authRepository),
        ),
        BlocProvider(
          create: (context) => CoinBloc(
            _authRepository,
            coinRepository: CoinRepository(
              dio: _dio,
              authRepository: _authRepository,
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UserBloc(
            userRepository: _userRepository,
            authRepository: _authRepository,
          )..add(CheckUserLoginEvent()),
        ),
        BlocProvider(
          create: (context) =>
              CategoryBloc(categoryRepository: _categoryRepository),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(authRepository: _authRepository),
        ),
        BlocProvider(
          create: (context) =>
              ResetPasswordBloc(authRepository: _authRepository),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider(
          create: (context) => StoryBloc(storyRepository: _storyRepository)
            ..add(FetchStoriesEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Gheseh Shab',
        theme: AppThemes.lightTheme, // تم روشن
        darkTheme: AppThemes.darkTheme, // تم تاریک
        themeMode: _themeMode, // حالت تم
        home: Directionality(
          textDirection: TextDirection.rtl, // راست‌چین کردن کل برنامه
          child: MainNavigationScreen(
            setThemeMode: _setThemeMode, // ارسال متد تغییر تم
          ),
        ),
      ),
    );
  }
}
