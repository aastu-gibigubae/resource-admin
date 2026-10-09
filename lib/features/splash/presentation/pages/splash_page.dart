import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/router/route_names.dart';
import '../../providers/splash_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(splashProvider, (previous, next) {
        next.whenData((status) {
          if (status == SplashStatus.authenticated) {
            context.go(RouteNames.dashboard);
          } else {
            context.go(RouteNames.login);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Bottom-left quarter circle decoration
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          // Bottom-right dot grid
          const Positioned(
            bottom: 32,
            right: 24,
            child: _DotGrid(),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BookLogo(),
                const SizedBox(height: 32),
                const Text('AASTU', style: AppTextStyles.displayLarge),
                const Text(
                  'FRESHMAN',
                  style: AppTextStyles.displayLarge,
                ),
                const Text(
                  'RESOURCE APP',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                const _SplitDivider(),
                const SizedBox(height: 16),
                Text(
                  "Admin's Page",
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Loading...',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Book logo widget ---
class _BookLogo extends StatelessWidget {
  const _BookLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sunburst rays behind the book
          CustomPaint(
            size: const Size(120, 120),
            painter: _SunburstPainter(),
          ),
          // Book body
          Positioned(
            bottom: 8,
            child: CustomPaint(
              size: const Size(80, 70),
              painter: _BookPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.7)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    const innerRadius = 30.0;
    const outerRadius = 52.0;
    const rayCount = 12;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi / rayCount) - math.pi / 2;
      canvas.drawLine(
        Offset(center.dx + innerRadius * math.cos(angle),
            center.dy + innerRadius * math.sin(angle)),
        Offset(center.dx + outerRadius * math.cos(angle),
            center.dy + outerRadius * math.sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Left page
    paint.color = AppColors.primary;
    final leftPath = Path()
      ..moveTo(size.width / 2, 4)
      ..quadraticBezierTo(size.width * 0.1, 0, 0, 8)
      ..lineTo(0, size.height - 10)
      ..quadraticBezierTo(size.width * 0.1, size.height - 14, size.width / 2, size.height - 8)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Right page
    paint.color = AppColors.primaryLight;
    final rightPath = Path()
      ..moveTo(size.width / 2, 4)
      ..quadraticBezierTo(size.width * 0.9, 0, size.width, 8)
      ..lineTo(size.width, size.height - 10)
      ..quadraticBezierTo(size.width * 0.9, size.height - 14, size.width / 2, size.height - 8)
      ..close();
    canvas.drawPath(rightPath, paint);

    // Spine
    paint.color = AppColors.primaryDark;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: 4, height: size.height - 4),
      paint,
    );

    // Bookmark triangle at the bottom
    paint.color = AppColors.accent;
    final bookmarkPath = Path()
      ..moveTo(size.width / 2 - 12, size.height)
      ..lineTo(size.width / 2 + 12, size.height)
      ..lineTo(size.width / 2, size.height - 14)
      ..close();
    canvas.drawPath(bookmarkPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Split divider widget ---
class _SplitDivider extends StatelessWidget {
  const _SplitDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(height: 2, color: AppColors.primary),
              ),
              Expanded(
                child: Container(height: 2, color: AppColors.accent),
              ),
            ],
          ),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4x4 dot grid widget ---
class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (row) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              4,
              (col) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.dotAccent.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
