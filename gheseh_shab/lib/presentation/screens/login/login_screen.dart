import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/logic/login/login_bloc.dart';
import 'package:gheseh_shab/logic/login/login_event.dart';
import 'package:gheseh_shab/logic/login/login_state.dart';
import 'package:gheseh_shab/presentation/screens/login/login_screen_2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = "+98"; // پیش‌فرض ایران
  final List<String> _countryCodes = [
    "+98",
    "+1",
    "+44",
    "+91",
    "+61",
    "+81"
  ]; // لیست پیش‌شماره‌ها

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context); // دسترسی به تم برنامه
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // رنگ پس‌زمینه از تم
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            // نمایش پیام بارگذاری
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("در حال ارسال شماره موبایل...")),
            );
          } else if (state is LoginSuccess) {
            // نمایش پیام موفقیت
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen2()));
          } else if (state is LoginFailure) {
            // نمایش پیام خطا
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // عنوان صفحه
                Text(
                  "ورود به حساب",
                  style: theme.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),

                // توضیحات
                Text(
                  "برای استفاده از اپلیکیشن قصه شب شماره موبایل خود را وارد کنید",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // بخش ورودی شماره موبایل
                Row(
                  children: [
                    // کد کشور
                    Container(
                      height: size.height * 0.07,
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        items: _countryCodes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: theme.textTheme.bodyText2?.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black45,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountryCode = newValue!;
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),

                    // فیلد شماره موبایل
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.07,
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: theme.textTheme.bodyText1,
                          decoration: InputDecoration(
                            hintText: "9120000000",
                            hintStyle: theme.inputDecorationTheme.hintStyle,
                            fillColor: theme.inputDecorationTheme.fillColor,
                            filled: theme.inputDecorationTheme.filled,
                            border: theme.inputDecorationTheme.border,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),

                // دکمه ورود
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null // غیرفعال کردن دکمه هنگام بارگذاری
                            : () {
                                final phoneNumber =
                                    _phoneController.text.trim();

                                // بررسی خالی بودن شماره موبایل
                                if (phoneNumber.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "لطفاً شماره موبایل خود را وارد کنید."),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                // بررسی صحت شماره موبایل (شروع با صفر و 10 رقم)
                                final isValidPhoneNumber =
                                    RegExp(r'^0[0-9]{10}$')
                                        .hasMatch(phoneNumber);
                                if (!isValidPhoneNumber) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "شماره موبایل وارد شده معتبر نیست."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // ارسال شماره موبایل به بلاک
                                context.read<LoginBloc>().add(
                                      SendPhoneNumberEvent(
                                          "$_selectedCountryCode$phoneNumber"),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor, // رنگ دکمه از تم
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.02),
                          ),
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "ارسال",
                                style: theme.textTheme.button?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
