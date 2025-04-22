import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/data/repositories/user_repository.dart';
import 'package:gheseh_shab/logic/navigation/navigation_bloc.dart';
import 'package:gheseh_shab/logic/navigation/navigation_event.dart';
import 'package:gheseh_shab/logic/navigation/navigation_state.dart';
import 'package:gheseh_shab/logic/user_info/user_bloc.dart';
import 'package:gheseh_shab/logic/user_info/user_event.dart';
import 'package:gheseh_shab/logic/user_info/user_state.dart';
import 'package:gheseh_shab/presentation/screens/about_us.dart';
import 'package:gheseh_shab/presentation/screens/dashbord/user_info.dart';
import 'package:gheseh_shab/presentation/screens/home_page.dart';
import 'package:gheseh_shab/presentation/screens/login/login_screen.dart';
import 'package:gheseh_shab/presentation/screens/pls_login%20screen.dart';
import 'package:gheseh_shab/presentation/screens/serch/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final Function(ThemeMode) onThemeChange;

  const CustomAppBar({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "قصه شب برای همه بچه‌های این سرزمین",
            textAlign: TextAlign.center,
            style: theme.appBarTheme.titleTextStyle,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            final themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
            onThemeChange(themeMode);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MainNavigationScreen extends StatelessWidget {
  final Function(ThemeMode) setThemeMode;

  MainNavigationScreen({Key? key, required this.setThemeMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final dio = Dio(BaseOptions(baseUrl: "https://qesseyeshab.ir/api"));
    final authRepo = AuthRepository(dio: dio);
    final userRepo = UserRepository(dio: dio, authRepository: authRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(
            userRepository: userRepo,
            authRepository: authRepo,
          )..add(CheckUserLoginEvent()),
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          isDarkMode: isDarkMode,
          onThemeChange: setThemeMode,
        ),
        body: _buildBody(userRepo),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBody(UserRepository userRepo) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final isLoggedIn = userState is UserLoggedIn;
        final pages = [
          HomePage(),
          isLoggedIn ? const SearchScreen() : const PleaseLoginScreen(),
          isLoggedIn
              ? Center(child: Text('صفحه پسندها'))
              : const PleaseLoginScreen(),
          isLoggedIn
              ? UserDetailsScreen(userRepository: userRepo)
              : LoginScreen(),
          AboutUsScreen()
        ];

        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            final currentIndex =
                state is PageChangedState ? state.currentPageIndex : 0;
            return IndexedStack(index: currentIndex, children: pages);
          },
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final isLoggedOut = userState is UserLoggedOut;

        return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            final currentIndex =
                state is PageChangedState ? state.currentPageIndex : 0;

            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                if (isLoggedOut && (index == 1 || index == 2)) {
                  context
                      .read<NavigationBloc>()
                      .add(ChangePageEvent(0)); // بازگشت به خانه
                } else {
                  context.read<NavigationBloc>().add(ChangePageEvent(index));
                }
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).unselectedWidgetColor,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'جستجو'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'پسندها'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'حساب'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.info), label: 'درباره ما'),
              ],
            );
          },
        );
      },
    );
  }
}
