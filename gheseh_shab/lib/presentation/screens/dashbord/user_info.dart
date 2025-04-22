import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/models/user_model.dart';
import 'package:gheseh_shab/data/repositories/invite_repository.dart';
import 'package:gheseh_shab/data/repositories/user_repository.dart';
import 'package:gheseh_shab/logic/user_info/user_bloc.dart';
import 'package:gheseh_shab/logic/user_info/user_event.dart';
import 'package:gheseh_shab/logic/user_info/user_state.dart';
import 'package:gheseh_shab/main.dart';
import 'package:gheseh_shab/presentation/screens/dashbord/accunt_update_screen.dart';
import 'package:gheseh_shab/presentation/screens/dashbord/by_token/buy_coin_screen.dart';
import 'package:gheseh_shab/presentation/screens/dashbord/by_token/invite_screen.dart';
import 'package:gheseh_shab/presentation/screens/dashbord/rutaite_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserRepository userRepository;

  const UserDetailsScreen({Key? key, required this.userRepository})
      : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await userRepository.authRepository.clearAllCache();
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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text('خطا: ${state.message}'));
          } else if (state is UserLoggedOut) {
            return const Center(child: Text('لطفاً وارد شوید.'));
          } else if (state is UserLoggedIn) {
            final user = UserModel.fromJson(state.user);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileCard(user, isDark),
                  const SizedBox(height: 16),
                  _buildMainButton(
                    context: context,
                    icon: Icons.edit,
                    label: 'ویرایش اطلاعات',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountUpdateScreen(),
                        ),
                      ).then((_) {
                        // پس از بازگشت از صفحه ویرایش، اطلاعات کاربر را دوباره بارگذاری کن
                        context.read<UserBloc>().add(CheckUserLoginEvent());
                      });
                    },
                    color: isDark ? Colors.blueGrey[700]! : Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildGridActions(context, isDark),
                  const SizedBox(height: 16),
                  _buildMainButton(
                    context: context,
                    icon: Icons.visibility_off,
                    label: 'دسته‌بندی‌های پنهان',
                    onPressed: () {
                      // TODO: نمایش دسته‌بندی‌های پنهان
                    },
                    color: isDark ? Colors.grey[700]! : Colors.cyan,
                  ),
                  const SizedBox(height: 16),
                  _buildMainButton(
                    context: context,
                    icon: Icons.logout,
                    label: 'خروج از حساب',
                    onPressed: () => _logout(context),
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('اطلاعاتی یافت نشد.'));
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
                const SizedBox(height: 8),
                Text(
                  'استان: ${user.province}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'شهر: ${user.city}',
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
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildGridActions(BuildContext context, bool isDark) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const WheelPage();
              }),
            );
          },
          isDark: isDark,
        ),
        _buildActionItem(
          icon: Icons.attach_money,
          label: 'خرید سکه',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CoinPurchaseScreen(),
              ),
            ).then((_) {
              context.read<UserBloc>().add(CheckUserLoginEvent());
            });
          },
          isDark: isDark,
        ),
        _buildActionItem(
          icon: Icons.group,
          label: 'دعوت دوستان',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InviteScreen(
                  inviteRepository: InviteRepository(
                    dio: userRepository.dio,
                    authRepository: userRepository.authRepository,
                  ),
                ),
              ),
            );
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
