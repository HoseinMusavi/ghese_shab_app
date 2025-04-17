import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/app.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:gheseh_shab/data/repositories/story_repository.dart';
import 'package:gheseh_shab/logic/auth/login_bloc.dart';
import 'package:gheseh_shab/logic/auth/login_event.dart';
import 'package:gheseh_shab/logic/auth/login_state.dart';
import 'package:gheseh_shab/main.dart';
import 'package:gheseh_shab/presentation/screens/login/new_pasword_screen.dart';

class LoginScreen3 extends StatelessWidget {
  final String phoneNumber; // شماره تلفن ارسال‌شده از صفحه قبلی
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen3({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context); // دسترسی به تم برنامه
    final isDarkMode = theme.brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        context.read<LoginBloc>().add(ResetLoginStateEvent());
        return true; // اجازه بازگشت به صفحه قبل
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          title: Text(
            "ورود به حساب",
            style: theme.appBarTheme.titleTextStyle,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<LoginBloc>().add(ResetLoginStateEvent());
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ورود به حساب",
                  style: theme.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "رمز عبور خود را وارد کنید",
                    style: theme.textTheme.bodyText2?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "شماره تلفن: $phoneNumber",
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: theme.textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: "رمز عبور",
                    hintStyle: theme.inputDecorationTheme.hintStyle,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    filled: theme.inputDecorationTheme.filled,
                    border: theme.inputDecorationTheme.border,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<LoginBloc>()
                          .add(ForgotPasswordEvent(phoneNumber));

                      // گوش دادن به وضعیت فراموشی رمز عبور
                      context.read<LoginBloc>().stream.listen((state) {
                        if (state is ForgotPasswordLoading) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("در حال ارسال درخواست...")),
                          );
                        } else if (state is ForgotPasswordSuccess) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewPasswordScreen(
                                phoneNumber: phoneNumber,
                              ),
                            ),
                          );
                        } else if (state is ForgotPasswordFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      });
                    },
                    child: Text(
                      "رمز خود را فراموش کردید؟",
                      style: theme.textTheme.bodyText2?.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("در حال ورود...")),
                      );
                    } else if (state is LoginSuccessWithToken) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("ورود موفق!")),
                      );

                      // هدایت به صفحه اصلی و حذف تمام صفحات قبلی از استک
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                        (route) => false, // حذف تمام صفحات قبلی
                      );
                    } else if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: state is LoginLoading
                              ? null
                              : () {
                                  final password =
                                      _passwordController.text.trim();

                                  if (password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "لطفاً رمز عبور خود را وارد کنید."),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<LoginBloc>().add(
                                        LoginWithPhoneAndPasswordEvent(
                                            phoneNumber, password),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                          ),
                          child: state is LoginLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "ورود",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
