import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('درباره ما'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'درباره ما',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ما در تیم قصه شب تلاش می‌کنیم تا بهترین داستان‌ها و محتواهای جذاب را برای شما فراهم کنیم. '
              'هدف ما ایجاد لحظاتی آرامش‌بخش و دلنشین برای شما و عزیزانتان است. '
              'با ما همراه باشید تا هر شب با داستان‌های جدید و شنیدنی، لحظات خوشی را تجربه کنید.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'تماس با ما',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ایمیل: info@ghesehshab.com\n'
              'تلفن: 123-456-7890',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
