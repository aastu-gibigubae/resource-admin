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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
          // ── Bottom-right quarter circle arc (stroked line, light blue) ──
           Positioned(
            right: -233,
            bottom: -233,
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFB8B8B8),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // ── Gold dot grid sits inside the visible arc area ──
          Positioned(
            bottom: 32,
            right: 20,
            child: const _DotGrid(),
          ),

          // ── Main centered content ──
=======
=======
>>>>>>> Stashed changes
          // Shared bottom-right decoration
          const BottomDecoration(),

          // Main content
>>>>>>> Stashed changes
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // Book + rays
                SizedBox(
                  width: 140,
                  height: 130,
                  child: const _BookLogoWidget(),
=======
=======
>>>>>>> Stashed changes
                // Book logo with rays
                SizedBox(
                  width: 140,
                  height: 130,
                  child: CustomPaint(
                    painter: _BookWithRaysPainter(),
                  ),
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                ),

                const SizedBox(height: 24),

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // AASTU
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // FRESHMAN
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // RESOURCE APP
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // Split divider
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                const _SplitDivider(),

                const SizedBox(height: 14),

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // Admin's Page
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
                // Loading spinner
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
// ─── Book logo ────────────────────────────────────────────────────────────────

class _BookLogoWidget extends StatelessWidget {
  const _BookLogoWidget();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(140, 130),
      painter: _BookWithRaysPainter(),
    );
  }
}

=======
// ─── Book with rays painter ───────────────────────────────────────────────────

>>>>>>> Stashed changes
=======
// ─── Book with rays painter ───────────────────────────────────────────────────

>>>>>>> Stashed changes
class _BookWithRaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final mid = w / 2;

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // ── Sunburst rays (top section, ~30% of height) ──
=======
    // ── Sunburst rays ──
>>>>>>> Stashed changes
=======
    // ── Sunburst rays ──
>>>>>>> Stashed changes
    final rayPaint = Paint()
      ..color = const Color(0xFFF9A825)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // Ray origin point (above the book spine top)
    final rayOriginX = mid;
    final rayOriginY = h * 0.32; // just above book top

    // Center ray — straight up
=======
    final rayOriginX = mid;
    final rayOriginY = h * 0.32;

    // Center ray
>>>>>>> Stashed changes
=======
    final rayOriginX = mid;
    final rayOriginY = h * 0.32;

    // Center ray
>>>>>>> Stashed changes
    canvas.drawLine(
      Offset(rayOriginX, rayOriginY - 8),
      Offset(rayOriginX, rayOriginY - 30),
      rayPaint,
    );
    // Left ray
    canvas.drawLine(
      Offset(rayOriginX - 5, rayOriginY - 7),
      Offset(rayOriginX - 18, rayOriginY - 26),
      rayPaint,
    );
    // Right ray
    canvas.drawLine(
      Offset(rayOriginX + 5, rayOriginY - 7),
      Offset(rayOriginX + 18, rayOriginY - 26),
      rayPaint,
    );

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // ── Book dimensions (bottom 70% of canvas) ──
=======
    // ── Book dimensions ──
>>>>>>> Stashed changes
=======
    // ── Book dimensions ──
>>>>>>> Stashed changes
    final bookTop = h * 0.30;
    final bookBottom = h * 0.92;
    final bookLeft = w * 0.08;
    final bookRight = w * 0.92;
    final bookH = bookBottom - bookTop;
    final bookW = bookRight - bookLeft;

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // ── Left outer dark blue cover ──
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    final darkBlue = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1A237E);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    final leftCover = Path()
      ..moveTo(mid - 2, bookTop)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.08, bookTop + bookH * 0.02,
          bookLeft, bookTop + bookH * 0.12)
      ..lineTo(bookLeft, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.08, bookBottom,
          mid - 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(leftCover, darkBlue);

    // ── Right outer dark blue cover ──
    final rightCover = Path()
      ..moveTo(mid + 2, bookTop)
      ..quadraticBezierTo(
          bookRight - bookW * 0.08, bookTop + bookH * 0.02,
          bookRight, bookTop + bookH * 0.12)
      ..lineTo(bookRight, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(
          bookRight - bookW * 0.08, bookBottom,
=======
    // Left outer cover
    final leftCover = Path()
      ..moveTo(mid - 2, bookTop)
      ..quadraticBezierTo(bookLeft + bookW * 0.08, bookTop + bookH * 0.02,
          bookLeft, bookTop + bookH * 0.12)
      ..lineTo(bookLeft, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.08, bookBottom, mid - 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(leftCover, darkBlue);

=======
    // Left outer cover
    final leftCover = Path()
      ..moveTo(mid - 2, bookTop)
      ..quadraticBezierTo(bookLeft + bookW * 0.08, bookTop + bookH * 0.02,
          bookLeft, bookTop + bookH * 0.12)
      ..lineTo(bookLeft, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.08, bookBottom, mid - 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(leftCover, darkBlue);

>>>>>>> Stashed changes
    // Right outer cover
    final rightCover = Path()
      ..moveTo(mid + 2, bookTop)
      ..quadraticBezierTo(bookRight - bookW * 0.08, bookTop + bookH * 0.02,
          bookRight, bookTop + bookH * 0.12)
      ..lineTo(bookRight, bookBottom - bookH * 0.06)
      ..quadraticBezierTo(bookRight - bookW * 0.08, bookBottom,
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
          mid + 2, bookBottom - bookH * 0.04)
      ..close();
    canvas.drawPath(rightCover, darkBlue);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // ── Left inner page (medium blue) ──
    final leftPagePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF64B5F6);

    final leftPage = Path()
      ..moveTo(mid - 2, bookTop + bookH * 0.02)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.18, bookTop + bookH * 0.01,
          bookLeft + bookW * 0.12, bookTop + bookH * 0.14)
      ..lineTo(bookLeft + bookW * 0.12, bookBottom - bookH * 0.10)
      ..quadraticBezierTo(
          bookLeft + bookW * 0.18, bookBottom - bookH * 0.04,
          mid - 2, bookBottom - bookH * 0.06)
      ..close();
    canvas.drawPath(leftPage, leftPagePaint);

    // ── Right inner page (lighter blue) ──
    final rightPagePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF90CAF9);

    final rightPage = Path()
      ..moveTo(mid + 2, bookTop + bookH * 0.02)
      ..quadraticBezierTo(
          bookRight - bookW * 0.18, bookTop + bookH * 0.01,
          bookRight - bookW * 0.12, bookTop + bookH * 0.14)
      ..lineTo(bookRight - bookW * 0.12, bookBottom - bookH * 0.10)
      ..quadraticBezierTo(
          bookRight - bookW * 0.18, bookBottom - bookH * 0.04,
          mid + 2, bookBottom - bookH * 0.06)
      ..close();
    canvas.drawPath(rightPage, rightPagePaint);

    // ── White/light highlight on right page ──
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withAlpha(100);
    final highlight = Path()
      ..moveTo(mid + 2, bookTop + bookH * 0.04)
      ..quadraticBezierTo(
          bookRight - bookW * 0.26, bookTop + bookH * 0.02,
          bookRight - bookW * 0.22, bookTop + bookH * 0.16)
      ..lineTo(bookRight - bookW * 0.22, bookBottom - bookH * 0.14)
      ..quadraticBezierTo(
          bookRight - bookW * 0.26, bookBottom - bookH * 0.08,
          mid + 2, bookBottom - bookH * 0.08)
      ..close();
    canvas.drawPath(highlight, highlightPaint);

    // ── Spine ──
=======
=======
>>>>>>> Stashed changes
    // Left inner page
    final leftPage = Path()
      ..moveTo(mid - 2, bookTop + bookH * 0.02)
      ..quadraticBezierTo(bookLeft + bookW * 0.18, bookTop + bookH * 0.01,
          bookLeft + bookW * 0.12, bookTop + bookH * 0.14)
      ..lineTo(bookLeft + bookW * 0.12, bookBottom - bookH * 0.10)
      ..quadraticBezierTo(bookLeft + bookW * 0.18, bookBottom - bookH * 0.04,
          mid - 2, bookBottom - bookH * 0.06)
      ..close();
    canvas.drawPath(
        leftPage, Paint()..color = const Color(0xFF64B5F6)..style = PaintingStyle.fill);

    // Right inner page
    final rightPage = Path()
      ..moveTo(mid + 2, bookTop + bookH * 0.02)
      ..quadraticBezierTo(bookRight - bookW * 0.18, bookTop + bookH * 0.01,
          bookRight - bookW * 0.12, bookTop + bookH * 0.14)
      ..lineTo(bookRight - bookW * 0.12, bookBottom - bookH * 0.10)
      ..quadraticBezierTo(bookRight - bookW * 0.18, bookBottom - bookH * 0.04,
          mid + 2, bookBottom - bookH * 0.06)
      ..close();
    canvas.drawPath(
        rightPage, Paint()..color = const Color(0xFF90CAF9)..style = PaintingStyle.fill);

    // White highlight on right page
    final highlight = Path()
      ..moveTo(mid + 2, bookTop + bookH * 0.04)
      ..quadraticBezierTo(bookRight - bookW * 0.26, bookTop + bookH * 0.02,
          bookRight - bookW * 0.22, bookTop + bookH * 0.16)
      ..lineTo(bookRight - bookW * 0.22, bookBottom - bookH * 0.14)
      ..quadraticBezierTo(bookRight - bookW * 0.26, bookBottom - bookH * 0.08,
          mid + 2, bookBottom - bookH * 0.08)
      ..close();
    canvas.drawPath(
        highlight, Paint()..color = Colors.white.withAlpha(100)..style = PaintingStyle.fill);

    // Spine
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    canvas.drawRect(
      Rect.fromLTWH(mid - 3, bookTop, 6, bookH - bookH * 0.04),
      darkBlue,
    );

<<<<<<< Updated upstream
<<<<<<< Updated upstream
    // ── Bottom open-book arc ──
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromLTWH(
        bookLeft + bookW * 0.08,
        bookBottom - bookH * 0.22,
        bookW * 0.84,
        bookH * 0.26,
      ),
      0,
      math.pi,
      false,
      arcPaint,
    );

    // ── Bookmark triangle ──
    final bmPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1A237E);
=======
=======
>>>>>>> Stashed changes
    // Bottom arc
    canvas.drawArc(
      Rect.fromLTWH(bookLeft + bookW * 0.08, bookBottom - bookH * 0.22,
          bookW * 0.84, bookH * 0.26),
      0, math.pi, false,
      Paint()
        ..color = const Color(0xFF1565C0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Bookmark triangle
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    final bm = Path()
      ..moveTo(mid - 9, bookBottom + 2)
      ..lineTo(mid + 9, bookBottom + 2)
      ..lineTo(mid, bookBottom - bookH * 0.14)
      ..close();
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    canvas.drawPath(bm, bmPaint);
=======
    canvas.drawPath(bm, Paint()..color = const Color(0xFF1A237E)..style = PaintingStyle.fill);
>>>>>>> Stashed changes
=======
    canvas.drawPath(bm, Paint()..color = const Color(0xFF1A237E)..style = PaintingStyle.fill);
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
              Expanded(
                child: Container(
                  height: 2,
                  color: const Color(0xFF1A237E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 2,
                  color: const Color(0xFFF9A825),
                ),
              ),
=======
              Expanded(child: Container(height: 2, color: AppColors.primaryDark)),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 2, color: AppColors.accent)),
>>>>>>> Stashed changes
=======
              Expanded(child: Container(height: 2, color: AppColors.primaryDark)),
              const SizedBox(width: 12),
              Expanded(child: Container(height: 2, color: AppColors.accent)),
>>>>>>> Stashed changes
            ],
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFF9A825),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< Updated upstream
<<<<<<< Updated upstream

// ─── Bottom-right arc painter ─────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x4D90CAF9) // light blue ~30% opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw a quarter circle arc (top-left quadrant of the circle)
    // Since the widget is positioned bottom-right off screen,
    // only the top-left portion is visible — that's the arc line we see
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      math.pi,        // start at left (180°)
      math.pi / 2,    // sweep 90° to bottom (270°)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (col) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9A825).withAlpha(200),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
