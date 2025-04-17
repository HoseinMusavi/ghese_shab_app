import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/models/user_model.dart';
import 'package:gheseh_shab/data/repositories/user_repository.dart';
import 'package:gheseh_shab/main.dart';
import 'package:gheseh_shab/presentation/screens/accunt_update_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserRepository userRepository;

  const UserDetailsScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = widget.userRepository.fetchUserInfo();
  }

  Future<void> _logout() async {
    await widget.userRepository.authRepository.clearToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MyApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<UserModel>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطا: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('اطلاعاتی یافت نشد.'));
          }

          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileCard(user, isDark),
                const SizedBox(height: 16),
                _buildMainButton(
                  icon: Icons.edit,
                  label: 'ویرایش اطلاعات',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountUpdateScreen(),
                      ),
                    );
                  },
                  color: isDark ? Colors.blueGrey[700]! : Colors.blue,
                ),
                const SizedBox(height: 16),
                _buildGridActions(isDark),
                const SizedBox(height: 16),
                _buildMainButton(
                  icon: Icons.visibility_off,
                  label: 'دسته‌بندی‌های پنهان',
                  onPressed: () {
                    // TODO: نمایش دسته‌بندی‌های پنهان
                  },
                  color: isDark ? Colors.grey[700]! : Colors.cyan,
                ),
                const SizedBox(height: 16),
                _buildMainButton(
                  icon: Icons.logout,
                  label: 'خروج از حساب',
                  onPressed: _logout,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(UserModel user, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                NetworkImage('https://qesseyeshab.ir${user.image}'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'موجودی: ${user.balance} سکه',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildGridActions(bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionItem(
          icon: Icons.casino,
          label: 'گردونه شانس',
          onTap: () {
            // TODO
          },
          isDark: isDark,
        ),
        _buildActionItem(
          icon: Icons.attach_money,
          label: 'خرید سکه',
          onTap: () {
            // TODO
          },
          isDark: isDark,
        ),
        _buildActionItem(
          icon: Icons.group,
          label: 'دعوت دوستان',
          onTap: () {
            // TODO
          },
          isDark: isDark,
        ),
        _buildActionItem(
          icon: Icons.card_giftcard,
          label: 'جایزه',
          onTap: () {
            // TODO
          },
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF062C42) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: isDark ? Colors.white : Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
