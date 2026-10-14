import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/widgets/bottom_decoration.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const BottomDecoration(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),

                SizedBox(
                  width: 140,
                  height: 130,
                  child: CustomPaint(painter: _BookWithRaysPainter()),
                ),

                const SizedBox(height: 24),

                const Text(
                  'AASTU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 2,
                    height: 1.15,
                  ),
                ),

                const Text(
                  'FRESHMAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 2,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'RESOURCE APP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                    letterSpacing: 2.5,
                  ),
                ),

                const SizedBox(height: 16),

                const _SplitDivider(),

                const SizedBox(height: 14),

                const Text(
                  "Admin's Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF555555),
                  ),
                ),

                SizedBox(height: screenHeight * 0.10),

                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.grey.shade400,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),

                SizedBox(height: screenHeight * 0.06),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Book with rays painter ───────────────────────────────────────────────────

class _BookWithRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mid = w / 2;

    final rayPaint = Paint()
      ..color = const Color(0xFFF9A825)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final rayOriginX = mid;
    final rayOriginY = h * 0.32;

    canvas.drawLine(Offset(rayOriginX, rayOriginY - 8),
        Offset(rayOriginX, rayOriginY - 30), rayPaint);
    canvas.drawLine(Offset(rayOriginX - 5, rayOriginY - 7),
        Offset(rayOriginX - 18, rayOriginY - 26), rayPaint);
    canvas.drawLine(Offset(rayOriginX + 5, rayOriginY - 7),
        Offset(rayOriginX + 18, rayOriginY - 26), rayPaint);

    final bookTop = h * 0.30;
    final bookBottom = h * 0.92;
    final bookLeft = w * 0.08;
    final bookRight = w * 0.92;
    final bookH = bookBottom - bookTop;
    final bookW = bookRight - bookLeft;

    final darkBlue = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1A237E);

    final leftCover = Path()
      ..moveTo(mid - 2, bookTop)
      ..quadraticBezierTo(bookLeft + bookW * 0.08, bookTop + bookH * 0.02,
          bookLeft, bookTop + bookH * 0.12)
      ..lineTo(bookLeft, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.08, bookBottom, mid - 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(leftCover, darkBlue);

    final rightCover = Path()
      ..moveTo(mid + 2, bookTop)
      ..quadraticBezierTo(bookRight - bookW * 0.08, bookTop + bookH * 0.02,
          bookRight, bookTop + bookH * 0.12)
      ..lineTo(bookRight, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(bookRight - bookW * 0.08, bookBottom,
          mid + 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(rightCover, darkBlue);

    canvas.drawPath(
      Path()
        ..moveTo(mid - 2, bookTop + bookH * 0.02)
        ..quadraticBezierTo(bookLeft + bookW * 0.18, bookTop + bookH * 0.01,
            bookLeft + bookW * 0.12, bookTop + bookH * 0.14)
        ..lineTo(bookLeft + bookW * 0.12, bookBottom - bookH * 0.10)
        ..quadraticBezierTo(bookLeft + bookW * 0.18, bookBottom - bookH * 0.04,
            mid - 2, bookBottom - bookH * 0.06)
        ..close(),
      Paint()..color = const Color(0xFF64B5F6)..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      Path()
        ..moveTo(mid + 2, bookTop + bookH * 0.02)
        ..quadraticBezierTo(bookRight - bookW * 0.18, bookTop + bookH * 0.01,
            bookRight - bookW * 0.12, bookTop + bookH * 0.14)
        ..lineTo(bookRight - bookW * 0.12, bookBottom - bookH * 0.10)
        ..quadraticBezierTo(bookRight - bookW * 0.18, bookBottom - bookH * 0.04,
            mid + 2, bookBottom - bookH * 0.06)
        ..close(),
      Paint()..color = const Color(0xFF90CAF9)..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      Path()
        ..moveTo(mid + 2, bookTop + bookH * 0.04)
        ..quadraticBezierTo(bookRight - bookW * 0.26, bookTop + bookH * 0.02,
            bookRight - bookW * 0.22, bookTop + bookH * 0.16)
        ..lineTo(bookRight - bookW * 0.22, bookBottom - bookH * 0.14)
        ..quadraticBezierTo(bookRight - bookW * 0.26, bookBottom - bookH * 0.08,
            mid + 2, bookBottom - bookH * 0.08)
        ..close(),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.39)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
        Rect.fromLTWH(mid - 3, bookTop, 6, bookH - bookH * 0.04), darkBlue);

    canvas.drawArc(
      Rect.fromLTWH(bookLeft + bookW * 0.08, bookBottom - bookH * 0.22,
          bookW * 0.84, bookH * 0.26),
      0, math.pi, false,
      Paint()
        ..color = const Color(0xFF1565C0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    canvas.drawPath(
      Path()
        ..moveTo(mid - 9, bookBottom + 2)
        ..lineTo(mid + 9, bookBottom + 2)
        ..lineTo(mid, bookBottom - bookH * 0.14)
        ..close(),
      Paint()..color = const Color(0xFF1A237E)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Split divider ────────────────────────────────────────────────────────────

class _SplitDivider extends StatelessWidget {
  const _SplitDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(child: Container(height: 2, color: AppColors.primaryDark)),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 2, color: AppColors.accent)),
            ],
          ),
          Container(
            width: 8,
            height: 8,
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
