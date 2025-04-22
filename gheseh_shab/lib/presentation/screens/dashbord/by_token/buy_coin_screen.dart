import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/logic/coin/coin_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinPurchaseScreen extends StatefulWidget {
  const CoinPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<CoinPurchaseScreen> createState() => _CoinPurchaseScreenState();
}

class _CoinPurchaseScreenState extends State<CoinPurchaseScreen> {
  bool _isCurrencyPayment = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('خرید سکه'),
          centerTitle: true,
          backgroundColor: isDarkMode ? const Color(0xFF0E2A3A) : Colors.white,
          elevation: 0,
        ),
        body: BlocConsumer<CoinBloc, CoinState>(
          listener: (context, state) {
            if (state is CoinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('در حال هدایت به درگاه پرداخت...')),
              );
              Future.delayed(const Duration(seconds: 1), () {
                launchUrl(Uri.parse(state.payLink));
              });
            } else if (state is CoinFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is CoinLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قصه شب برای همه بچه‌های این سرزمین',
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(بنیاد نظریانی | Nazariani.org)',
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  if (!_isCurrencyPayment)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'قبل از پرداخت حتما فیلترشکن خود را خاموش کنید',
                              style: theme.textTheme.bodyText2?.copyWith(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.blue[900],
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'خرید سکه',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سکه‌های شما: 6',
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.grey[800],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  if (!_isCurrencyPayment) ...[
                    Text(
                      'مقدار سکه مورد نیاز خود را انتخاب کنید',
                      style: theme.textTheme.bodyText2?.copyWith(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildCoinOption(context, 10, '10,000 تومان'),
                        _buildCoinOption(context, 20, '20,000 تومان'),
                        _buildCoinOption(context, 50, '50,000 تومان'),
                        _buildCoinOption(context, 100, '100,000 تومان'),
                      ],
                    ),
                  ] else ...[
                    Text(
                      'مقدار سکه مورد نیاز خود را انتخاب کنید',
                      style: theme.textTheme.bodyText2?.copyWith(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildCoinOption(context, 100, '5€'),
                        _buildCoinOption(context, 200, '10€'),
                        _buildCoinOption(context, 500, '25€'),
                        _buildCoinOption(context, 1000, '50€'),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    '«با ادامه فرآیند خرید، قوانین و مقررات را می‌پذیرم.»',
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سیاست حریم شخصی (Privacy Policy)',
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontSize: 12,
                      color: isDarkMode ? Colors.tealAccent : Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isCurrencyPayment = !_isCurrencyPayment;
                      });
                    },
                    icon: const Icon(Icons.currency_exchange),
                    label: Text(
                      _isCurrencyPayment ? 'پرداخت ریالی' : 'پرداخت ارزی',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      foregroundColor:
                          isDarkMode ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  Widget _buildCoinOption(BuildContext context, int amount, String price) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        context.read<CoinBloc>().add(BuyCoinsEvent(amount));
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1A3B4C) : const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black38 : Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on,
                color: isDarkMode ? Colors.amberAccent : Colors.teal, size: 32),
            const SizedBox(height: 8),
            Text(
              '$amount سکه',
              style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: theme.textTheme.bodyText2?.copyWith(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
