import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PleaseLoginScreen extends StatelessWidget {
  const PleaseLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // دایره رنگی پشت انیمیشن
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.yellow : Colors.lightBlue[100],
                  shape: BoxShape.circle,
                ),
              ),

              // انیمیشن لوتی
              Lottie.network(
                'https://lottie.host/7fbe5606-b734-4fd2-bb45-7a8455c46374/uKxrO4KCoR.json', // لینک انیمیشن آنلاین
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // متن زیر انیمیشن
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "لطفا ابتدا از صفحه حساب وارد حساب کاربری خود شوید",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
