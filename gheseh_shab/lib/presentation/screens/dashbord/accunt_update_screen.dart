import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../logic/user_info/user_bloc.dart';
import '../../../logic/user_info/user_event.dart';
import '../../../logic/user_info/user_state.dart';

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
    'آذربایجان شرقی',
    'آذربایجان غربی',
    'اردبیل',
    'اصفهان',
    'البرز',
    'ایلام',
    'بوشهر',
    'تهران',
    'چهارمحال و بختیاری',
    'خراسان جنوبی',
    'خراسان رضوی',
    'خراسان شمالی',
    'خوزستان',
    'زنجان',
    'سمنان',
    'سیستان و بلوچستان',
    'فارس',
    'قزوین',
    'قم',
    'کردستان',
    'کرمان',
    'کرمانشاه',
    'کهگیلویه و بویراحمد',
    'گلستان',
    'گیلان',
    'لرستان',
    'مازندران',
    'مرکزی',
    'هرمزگان',
    'همدان',
    'یزد'
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

  void _submitForm() {
    final userInfo = {
      'first_name': _nameController.text,
      'last_name': _lastNameController.text,
      'birthday': _selectedDate ?? '',
      'gender': _selectedGender ?? '',
      'country': 'ایران', // مقدار پیش‌فرض
      'province': _selectedProvince ?? '',
      'city': _selectedCity ?? '',
    };

    context.read<UserBloc>().add(
          UpdateUserInfoEvent(userInfo: userInfo, image: _selectedImage),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl, // راست‌چین کردن کل صفحه
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ویرایش حساب کاربری'),
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserUpdated) {
              // ارسال رویداد برای به‌روزرسانی اطلاعات کاربر
              context.read<UserBloc>().add(CheckUserLoginEvent());
              // بستن صفحه
              Navigator.pop(context);
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserUpdating) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نام', style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'نام خود را وارد کنید',
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: InputBorder.none, // حذف خط دور
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('نام خانوادگی', style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'نام خانوادگی خود را وارد کنید',
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: InputBorder.none, // حذف خط دور
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('عکس', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('انتخاب عکس'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode ? Colors.teal : Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_selectedImage != null)
                        CircleAvatar(
                          radius: 40,
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
                      OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('انتخاب تاریخ'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDarkMode ? Colors.teal : Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_selectedDate != null)
                        Flexible(
                          child: Text(
                            _selectedDate!,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('جنسیت', style: TextStyle(fontSize: 16)),
                  DropdownButtonFormField<String>(
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: InputBorder.none, // حذف خط دور
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('استان', style: TextStyle(fontSize: 16)),
                  DropdownButtonFormField<String>(
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: InputBorder.none, // حذف خط دور
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('شهر یا روستا', style: TextStyle(fontSize: 16)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'نام شهر یا روستا را وارد کنید',
                      filled: true,
                      fillColor:
                          isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: InputBorder.none, // حذف خط دور
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.teal : Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('ثبت تغییرات'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
