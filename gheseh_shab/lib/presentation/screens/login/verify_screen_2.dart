import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/logic/auth/login_bloc.dart';
import 'package:gheseh_shab/logic/auth/login_event.dart';
import 'package:gheseh_shab/logic/auth/login_state.dart';
import 'package:gheseh_shab/presentation/screens/home_page.dart';
import 'package:gheseh_shab/presentation/screens/login/regester_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String phoneNumber; // شماره تلفن برای ارسال به API

  const VerifyScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late LoginBloc _loginBloc; // ذخیره مرجع به LoginBloc
  final TextEditingController _codeController = TextEditingController();
  late Timer _timer;
  int _remainingTime = 180; // 3 دقیقه (180 ثانیه)

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ذخیره مرجع به LoginBloc
    _loginBloc = context.read<LoginBloc>();
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    _loginBloc.add(ResetLoginStateEvent()); // استفاده از مرجع ذخیره‌شده
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
    _loginBloc.add(SendPhoneNumberEvent(
        widget.phoneNumber.toString())); // استفاده از مرجع ذخیره‌شده
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("کد تأیید مجدداً ارسال شد.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تأیید شماره موبایل"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _loginBloc.add(ResetLoginStateEvent()); // استفاده از مرجع ذخیره‌شده
            Navigator.of(context).pop(); // بازگشت به صفحه قبلی
          },
        ),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
          } else if (state is VerifyCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RegisterScreen(
                  phoneNumber: widget.phoneNumber,
                  code: _codeController.text.trim(),
                ),
              ),
            );
          } else if (state is VerifyCodeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "کد تأیید ارسال شده به شماره ${widget.phoneNumber} را وارد کنید.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    hintText: "کد تأیید",
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    filled: Theme.of(context).inputDecorationTheme.filled,
                    border: Theme.of(context).inputDecorationTheme.border,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_remainingTime == 0) {
                          _resendCode();
                        }
                      },
                      child: Text(
                        _remainingTime == 0
                            ? "ارسال مجدد کد"
                            : "ارسال مجدد در ${_formatTime(_remainingTime)}",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: _remainingTime == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                final code = _codeController.text.trim();
                                if (code.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("لطفاً کد تأیید را وارد کنید."),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }
                                _loginBloc.add(
                                  VerifyCodeEvent(widget.phoneNumber, code),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.02),
                          ),
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "تأیید",
                                style: TextStyle(
                                  fontSize: 16,
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
