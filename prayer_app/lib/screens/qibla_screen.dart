import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class QiblaScreen extends StatefulWidget {
  final bool isDark;
  const QiblaScreen({super.key, required this.isDark});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotController;

  @override
  void initState() {
    super.initState();
    _rotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _rotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: AppBar(
        title: const Text('اتجاه القبلة', style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        foregroundColor: isDark ? AppTheme.darkText : AppTheme.lightText,
      ),
      body: StreamBuilder<QiblahDirection>(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGold),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'تعذر تحديد اتجاه القبلة\nتأكد من تفعيل البوصلة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final qiblahDirection = snapshot.data!;
          final qiblahAngle = qiblahDirection.qiblah * (math.pi / 180) * -1;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'وجِّه الجهاز نحو اتجاه القبلة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 50),

                // Compass
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer ring
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                          border: Border.all(
                            color: AppTheme.primaryGold.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGold.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),

                      // Compass directions
                      ..._buildDirectionLabels(isDark),

                      // Needle
                      Transform.rotate(
                        angle: qiblahAngle,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Kaaba icon
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.mosque_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.primaryGold,
                                    AppTheme.primaryGold.withOpacity(0),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Center dot
                      Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${qiblahDirection.qiblah.toStringAsFixed(1)}° من الشمال',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildDirectionLabels(bool isDark) {
    const directions = [
      {'label': 'ش', 'angle': 0.0},
      {'label': 'شر', 'angle': 45.0},
      {'label': 'ق', 'angle': 90.0},
      {'label': 'جنشر', 'angle': 135.0},
      {'label': 'ج', 'angle': 180.0},
      {'label': 'جنغ', 'angle': 225.0},
      {'label': 'غ', 'angle': 270.0},
      {'label': 'شغ', 'angle': 315.0},
    ];

    return directions.map((d) {
      final angle = (d['angle'] as double) * math.pi / 180;
      final r = 115.0;
      final x = r * math.sin(angle);
      final y = -r * math.cos(angle);

      return Transform.translate(
        offset: Offset(x, y),
        child: Text(
          d['label'] as String,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
          ),
        ),
      );
    }).toList();
  }
}
