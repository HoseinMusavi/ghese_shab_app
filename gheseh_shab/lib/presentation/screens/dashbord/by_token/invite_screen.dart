import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // اضافه کردن برای کپی کردن متن
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/repositories/invite_repository.dart';
import 'package:gheseh_shab/logic/user_info/user_bloc.dart';
import 'package:gheseh_shab/logic/user_info/user_state.dart';

class InviteScreen extends StatelessWidget {
  final InviteRepository inviteRepository;

  const InviteScreen({Key? key, required this.inviteRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // دریافت شماره تلفن کاربر از UserState
    final userState = context.read<UserBloc>().state;
    final phoneNumber = userState is UserLoggedIn
        ? userState.user['phone'].toString()
        : 'نامشخص'; // شماره تلفن کاربر

    return Scaffold(
      appBar: AppBar(
        title: const Text('دعوت از دوستان'),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF0E2A3A) : Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: inviteRepository.fetchInvitedUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'خطا در دریافت اطلاعات: ${snapshot.error}',
                style: theme.textTheme.bodyText1?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _buildInviteContent(
              theme,
              isDarkMode,
              phoneNumber,
              'شما تا به حال کسی را دعوت نکرده‌اید.',
            );
          } else {
            return _buildInviteContent(
              theme,
              isDarkMode,
              phoneNumber,
              'افراد دعوت‌شده:',
              invitedUsers: snapshot.data!,
            );
          }
        },
      ),
    );
  }

  Widget _buildInviteContent(
    ThemeData theme,
    bool isDarkMode,
    String phoneNumber,
    String message, {
    List<dynamic>? invitedUsers,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'شما می‌توانید با دعوت از دوستان خود به برنامه سکه رایگان دریافت کنید.',
            style: theme.textTheme.bodyText1?.copyWith(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'کافیست دوست شما در هنگام ثبت نام کد دعوت شما را وارد کند و بعد از آن ۳۰ سکه به شما و ۳۰ سکه هم به دوستتان هدیه داده می‌شود.',
            style: theme.textTheme.bodyText2?.copyWith(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'کد دعوت شما: $phoneNumber',
                  style: theme.textTheme.bodyText1?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.amberAccent : Colors.teal,
                  ),
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: isDarkMode ? Colors.amberAccent : Colors.teal,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: phoneNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('کد دعوت کپی شد!'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyText2?.copyWith(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          if (invitedUsers != null) ...[
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: invitedUsers.length,
                itemBuilder: (context, index) {
                  final user = invitedUsers[index];
                  return ListTile(
                    title: Text(
                      user['name'] ?? 'نامشخص',
                      style: theme.textTheme.bodyText1?.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      user['email'] ?? 'ایمیل نامشخص',
                      style: theme.textTheme.bodyText2?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
