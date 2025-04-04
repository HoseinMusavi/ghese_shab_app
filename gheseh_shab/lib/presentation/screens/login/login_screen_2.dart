import 'dart:async';
import 'package:flutter/material.dart';

class LoginScreen2 extends StatefulWidget {
  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final TextEditingController _codeController = TextEditingController();
  late Timer _timer;
  int _remainingTime = 180; // 3 دقیقه (180 ثانیه)

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  void _resendCode() {
    setState(() {
      _remainingTime = 180; // ریست کردن تایمر به 3 دقیقه
    });
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("کد تأیید مجدداً ارسال شد.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0E2A3A), // رنگ پس‌زمینه تیره
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // عنوان صفحه
              Text(
                "ورود به حساب",
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.01),

              // توضیحات
              Text(
                "کد تایید ارسال شده برایتان را وارد کنید",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // فیلد کد تایید
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: size.width * 0.04),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "کد تایید",
                  hintStyle: TextStyle(fontSize: size.width * 0.035),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                    horizontal: size.width * 0.03,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.02),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),

              // تایمر و دکمه ارسال مجدد
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _remainingTime == 0
                        ? _resendCode
                        : null, // فعال‌سازی دکمه در صورت صفر شدن تایمر
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      backgroundColor: _remainingTime == 0
                          ? const Color(0xFF17A589) // رنگ سبز برای دکمه فعال
                          : Colors.grey[400], // رنگ خاکستری برای دکمه غیرفعال
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _remainingTime == 0
                          ? "ارسال مجدد کد"
                          : "ارسال مجدد در ${_formatTime(_remainingTime)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),

              // دکمه ورود
              SizedBox(
                width: double.infinity,
                height: size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    final code = _codeController.text.trim();
                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("لطفاً کد تایید را وارد کنید."),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }
                    // عملکرد ورود
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("کد وارد شده: $code")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF17A589), // رنگ سبز دکمه
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                  ),
                  child: const Text(
                    "ورود",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
