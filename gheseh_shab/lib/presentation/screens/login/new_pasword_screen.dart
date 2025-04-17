import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/logic/auth/reset_password_bloc.dart';
import 'package:gheseh_shab/logic/auth/reset_password_event.dart';
import 'package:gheseh_shab/logic/auth/reset_password_state.dart';
import 'package:gheseh_shab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPasswordScreen extends StatefulWidget {
  final String phoneNumber;

  const NewPasswordScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("بازنشانی رمز عبور"),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) async {
          if (state is ResetPasswordSuccess) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', state.token);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("رمز عبور با موفقیت تغییر کرد!"),
                  backgroundColor: theme.primaryColor,
                ),
              );

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
                (route) => false, // حذف تمام صفحات قبلی
              );
            }
          } else if (state is ResetPasswordFailure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "کد تأیید ارسال شده به شماره ${widget.phoneNumber} را وارد کنید.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText2,
              ),
              SizedBox(height: size.height * 0.03),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: "کد تأیید",
                  hintStyle: theme.inputDecorationTheme.hintStyle,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: theme.inputDecorationTheme.filled,
                  border: theme.inputDecorationTheme.border,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: theme.textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: "رمز عبور جدید",
                  hintStyle: theme.inputDecorationTheme.hintStyle,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  filled: theme.inputDecorationTheme.filled,
                  border: theme.inputDecorationTheme.border,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: state is ResetPasswordLoading
                          ? null
                          : () {
                              final code = _codeController.text.trim();
                              final password = _passwordController.text.trim();

                              if (code.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        "لطفاً تمام فیلدهای ضروری را پر کنید."),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              if (code.length != 4 ||
                                  int.tryParse(code) == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        "کد تأیید باید 4 رقم عددی باشد."),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              if (password.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        "رمز عبور باید حداقل 4 کاراکتر باشد."),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              context.read<ResetPasswordBloc>().add(
                                    ResetPasswordSubmitted(
                                      phoneNumber: widget.phoneNumber,
                                      password: password,
                                      code: code,
                                    ),
                                  );
                            },
                      child: const Text("بازنشانی رمز"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
