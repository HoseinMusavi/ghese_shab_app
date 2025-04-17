import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';

class TokenScreen extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository(dio: Dio());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مشاهده توکن"),
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: authRepository.getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("خطا: ${snapshot.error}");
            } else if (snapshot.hasData && snapshot.data != null) {
              return Text("توکن ذخیره‌شده: ${snapshot.data}");
            } else {
              return const Text("توکن یافت نشد.");
            }
          },
        ),
      ),
    );
  }
}
