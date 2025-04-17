import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/app.dart';
import 'package:gheseh_shab/logic/auth/register/register_bloc.dart';
import 'package:gheseh_shab/logic/auth/register/register_event.dart';
import 'package:gheseh_shab/logic/auth/register/register_state.dart';
import 'package:gheseh_shab/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final String phoneNumber;
  final String code;

  RegisterScreen({Key? key, required this.phoneNumber, required this.code})
      : super(key: key);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("تکمیل ثبت‌نام"),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF0E2A3A) : Colors.white,
        elevation: 0,
      ),
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) async {
          if (state is RegisterSuccess) {
            // ذخیره توکن در حافظه محلی
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', state.token);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("ثبت‌نام موفقیت‌آمیز بود!")),
            );

            // هدایت به صفحه اصلی به صورت بهینه
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ),
              (route) => false, // حذف تمام صفحات قبلی
            );
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "لطفا اطلاعات خود را وارد کنید و یک رمز برای حساب‌تان انتخاب کنید",
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: "نام",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    border: InputBorder.none, // حذف خط دور
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: "نام خانوادگی",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    border: InputBorder.none, // حذف خط دور
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "رمز عبور",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    border: InputBorder.none, // حذف خط دور
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inviteCodeController,
                  decoration: InputDecoration(
                    hintText: "کد معرف (اختیاری)",
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    border: InputBorder.none, // حذف خط دور
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: state is RegisterLoading
                          ? null
                          : () {
                              final firstName =
                                  _firstNameController.text.trim();
                              final lastName = _lastNameController.text.trim();
                              final password = _passwordController.text.trim();
                              final inviteCode =
                                  _inviteCodeController.text.trim();

                              if (firstName.isEmpty ||
                                  lastName.isEmpty ||
                                  password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "لطفاً تمام فیلدهای ضروری را پر کنید."),
                                  ),
                                );
                                return;
                              }

                              context.read<RegisterBloc>().add(
                                    RegisterUserEvent(
                                      phone: phoneNumber,
                                      firstName: firstName,
                                      lastName: lastName,
                                      password: password,
                                      code: code,
                                      inviteCode: inviteCode,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.teal : Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("ثبت‌نام"),
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
