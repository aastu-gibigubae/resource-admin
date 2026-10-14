import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class QuickActionGrid extends ConsumerWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = [
      (
        label: 'Manage Users',
        icon: Icons.people,
        onTap: () => context.go(RouteNames.userManagement),
      ),
      (
        label: 'Pending Reports',
        icon: Icons.report_problem_outlined,
        onTap: () => context.go(RouteNames.pendingRequests),
      ),
      (
        label: 'Upload Resource',
        icon: Icons.upload_file,
        onTap: () => context.go(RouteNames.uploadResources),
      ),
      (
        label: 'My Profile',
        icon: Icons.person_outline,
        onTap: () => context.go(RouteNames.profile),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: actions
          .map((a) => _ActionCard(icon: a.icon, label: a.label, onTap: a.onTap))
          .toList(),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(label, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
