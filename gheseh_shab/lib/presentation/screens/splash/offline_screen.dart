import 'package:flutter/material.dart';
import 'package:gheseh_shab/presentation/screens/pls_login%20screen.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // آیکون یا تصویر آفلاین
          Icon(
            Icons.wifi_off,
            size: 100,
            color: isDarkMode ? Colors.yellow : Colors.blue,
          ),
          const SizedBox(height: 24),

          // متن آفلاین
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "شما آفلاین هستید. لطفاً اتصال به اینترنت خود را بررسی کنید.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // دکمه ورود به بخش آفلاین
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PleaseLoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ورود به بخش آفلاین',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
