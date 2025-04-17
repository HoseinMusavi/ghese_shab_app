import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/logic/auth/login_bloc.dart';
import 'package:gheseh_shab/logic/auth/login_event.dart';
import 'package:gheseh_shab/logic/auth/login_state.dart';
import 'package:gheseh_shab/presentation/screens/login/verify_screen_2.dart';
import 'package:gheseh_shab/presentation/screens/login/login_screen_3.dart';

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
          } else if (state is RegisterNeeded) {
            // انتقال به صفحه ثبت‌نام
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VerifyScreen(
                  phoneNumber:
                      "${_selectedCountryCode}${_phoneController.text.trim()}"),
            ));
          } else if (state is LoginAlready) {
            // انتقال به صفحه ورود
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoginScreen3(
                  phoneNumber:
                      "${_selectedCountryCode}${_phoneController.text.trim()}"),
            ));

            // بازنشانی وضعیت پس از هدایت
            context.read<LoginBloc>().add(ResetLoginStateEvent());
          } else if (state is LoginFailure) {
            // نمایش پیام خطا
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)), // Display the error message
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
                            hintText: "09120000000",
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
                    if (state is LoginInitial || state is LoginFailure) {
                      return SizedBox(
                        width: double.infinity,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            final phoneNumber = _phoneController.text.trim();

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

                            context.read<LoginBloc>().add(
                                  SendPhoneNumberEvent(
                                      "$_selectedCountryCode$phoneNumber"),
                                );
                            print('شماره ارسال شده برا کد' +
                                "$_selectedCountryCode$phoneNumber");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.primaryColor, // رنگ دکمه از تم
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                          ),
                          child: Text(
                            "ارسال",
                            style: theme.textTheme.button?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    } else if (state is LoginLoading) {
                      return SizedBox(
                        width: double.infinity,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: null, // غیرفعال کردن دکمه هنگام بارگذاری
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
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
