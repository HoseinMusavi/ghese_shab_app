import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: WheelPage()));

class WheelPage extends StatefulWidget {
  const WheelPage({super.key});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  String _winner = '';
  List<String> _recentWinners = [];

  // لیست فیک آیتم‌ها
  final List<Map<String, String>> items = [
    {
      'name': 'جایزه نقدی',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
    {
      'name': 'کارت هدیه',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
    {
      'name': 'گوشی هوشمند',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
    {
      'name': 'سفر رایگان',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
    {
      'name': 'لپ‌تاپ',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
    {
      'name': 'دوربین عکاسی',
      'image': 'https://qesseyeshab.ir/s3/115_IMAGE_677bc9b9b6240.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )..addListener(() => setState(() => _angle = _animation.value));
  }

  void _startSpin() {
    final random = Random();
    final spins = 8 + random.nextInt(4);
    final degreesPerSection = 2 * pi / items.length;
    final randomOffset = random.nextDouble() * degreesPerSection;
    final targetAngle = _angle + spins * 2 * pi + randomOffset;

    final finalAngle = targetAngle % (2 * pi);
    final winnerIndex =
        (items.length - (finalAngle / (2 * pi) * items.length).floor()) %
            items.length;
    setState(() {
      _winner = "برنده: ${items[winnerIndex]['name']}";
      _recentWinners.insert(0, _winner);
      if (_recentWinners.length > 5) _recentWinners.removeLast();
    });

    _animation = Tween<double>(begin: _angle, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWheel(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circle with enhanced gradient
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.indigo.shade900, Colors.purple.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
        ),
        // Wheel slices
        ...List.generate(items.length, (index) {
          final anglePerItem = 2 * pi / items.length;
          final rotation = index * anglePerItem;
          final item = items[index];

          return Transform.rotate(
            angle: rotation + _angle,
            child: ClipPath(
              clipper: WheelSliceClipper(items.length),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(item['image']!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      item['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        // Center button with enhanced design
        GestureDetector(
          onTap: _controller.isAnimating ? null : _startSpin,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.yellow.shade200, Colors.orange.shade700],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "شروع چرخش",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointer() {
    return AnimatedRotation(
      turns: _controller.isAnimating ? 0 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: 60,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.red.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_drop_down,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wheelSize = size.width > 600 ? 400.0 : size.width * 0.85;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey.shade900, Colors.black87],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "چرخونه شانس",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),
              ),
              // Wheel and Pointer
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildWheel(wheelSize),
                      Positioned(
                        top: 0,
                        child: _buildPointer(),
                      ),
                    ],
                  ),
                ),
              ),
              // Winner announcement
              AnimatedOpacity(
                opacity: _winner.isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    _winner,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Recent winners
              if (_recentWinners.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "برندگان اخیر:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ..._recentWinners.map((winner) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              winner,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class WheelSliceClipper extends CustomClipper<Path> {
  final int slices;

  WheelSliceClipper(this.slices);

  @override
  Path getClip(Size size) {
    final angle = 2 * pi / slices;
    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(
      size.width / 2 + size.width * cos(-angle / 2),
      size.height / 2 + size.height * sin(-angle / 2),
    );
    path.arcTo(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -angle / 2,
      angle,
      false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
