import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountUpdateScreen extends StatefulWidget {
  const AccountUpdateScreen({Key? key}) : super(key: key);

  @override
  _AccountUpdateScreenState createState() => _AccountUpdateScreenState();
}

class _AccountUpdateScreenState extends State<AccountUpdateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedDate;
  String? _selectedGender;
  String? _selectedProvince;
  String? _selectedCity;
  XFile? _selectedImage;

  final List<String> _genders = ['مرد', 'زن', 'نامشخص'];
  final List<String> _provinces = [
    'تهران',
    'اصفهان',
    'فارس',
    'خراسان رضوی',
    'آذربایجان شرقی',
    'مازندران',
    'گیلان',
    'کرمان',
    'یزد',
    'هرمزگان',
    'سیستان و بلوچستان',
    'و ...' // لیست کامل استان‌ها
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickDate() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked.formatFullDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایش حساب کاربری'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('نام', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'نام خود را وارد کنید',
              ),
            ),
            const SizedBox(height: 16),
            const Text('نام خانوادگی', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: 'نام خانوادگی خود را وارد کنید',
              ),
            ),
            const SizedBox(height: 16),
            const Text('عکس', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('انتخاب عکس'),
                ),
                const SizedBox(width: 16),
                if (_selectedImage != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: FileImage(
                      File(_selectedImage!.path),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('تاریخ تولد', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('انتخاب تاریخ'),
                ),
                const SizedBox(width: 16),
                if (_selectedDate != null)
                  Text(
                    _selectedDate!,
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('جنسیت', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedGender,
              hint: const Text('انتخاب جنسیت'),
              items: _genders
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('استان', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: _selectedProvince,
              hint: const Text('انتخاب استان'),
              items: _provinces
                  .map((province) => DropdownMenuItem(
                        value: province,
                        child: Text(province),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProvince = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('شهر یا روستا', style: TextStyle(fontSize: 16)),
            TextField(
              decoration: const InputDecoration(
                hintText: 'نام شهر یا روستا را وارد کنید',
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // ارسال اطلاعات به سرور
                },
                child: const Text('ثبت تغییرات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
