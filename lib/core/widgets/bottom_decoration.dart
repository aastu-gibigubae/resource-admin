import 'package:flutter/material.dart';

/// Shared bottom-right decoration used across screens (splash, login, etc.)
/// Shows a large stroked circle partially off-screen with a gold dot grid.
class BottomDecoration extends StatelessWidget {
  const BottomDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Large circle border — partially clipped off bottom-right
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

        // Gold dot grid
        const Positioned(
          bottom: 32,
          right: 20,
          child: _DotGrid(),
        ),
      ],
    );
  }
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
