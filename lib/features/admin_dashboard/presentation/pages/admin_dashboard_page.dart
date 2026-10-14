import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../providers/dashboard_provider.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/pending_report_tile.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/recent_activity_tile.dart';
import '../widgets/stat_card.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
      case 1:
        context.go(RouteNames.userManagement);
      case 2:
        context.go(RouteNames.uploadResources);
      case 3:
        context.go(RouteNames.profile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: dashboardState.when(
        loading: () => const AppLoader(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (data) => _DashboardBody(data: data),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.upload_file),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (i) => _navigate(context, i),
      ),
    );
  }
}

class _DashboardBody extends ConsumerStatefulWidget {
  final DashboardData data;

  const _DashboardBody({required this.data});

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  final Set<int> _resolvingIds = {};

  Future<void> _resolveReport(int reportId) async {
    setState(() => _resolvingIds.add(reportId));
    try {
      await ref.read(dashboardProvider.notifier).resolveReport(reportId);
    } finally {
      if (mounted) setState(() => _resolvingIds.remove(reportId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.data.stats;
    final pendingReports = widget.data.pendingReports;
    final recentActivity = widget.data.recentActivity;

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const DashboardHeader(),
            const SizedBox(height: 16),

            // Overview section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Overview', style: AppTextStyles.titleMedium),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    label: 'Total Users',
                    value: stats.totalUsers.toString(),
                    icon: Icons.people,
                    color: AppColors.primary,
                  ),
                  StatCard(
                    label: 'Pending Reports',
                    value: stats.pendingReports.toString(),
                    icon: Icons.report_problem,
                    color: AppColors.warning,
                  ),
                  StatCard(
                    label: 'Total Resources',
                    value: stats.totalResources.toString(),
                    icon: Icons.library_books,
                    color: AppColors.success,
                  ),
                  StatCard(
                    label: 'Active Premium',
                    value: stats.activePremium.toString(),
                    icon: Icons.star,
                    color: AppColors.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Quick Actions', style: AppTextStyles.titleMedium),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: QuickActionGrid(),
            ),
            const SizedBox(height: 24),

            // Pending Reports section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Pending Reports', style: AppTextStyles.titleMedium),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.pendingRequests),
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
            if (pendingReports.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'No pending reports',
                  style: AppTextStyles.bodySmall,
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingReports.length > 5 ? 5 : pendingReports.length,
                itemBuilder: (context, index) {
                  final report = pendingReports[index];
                  return PendingReportTile(
                    report: report,
                    isResolving: _resolvingIds.contains(report.id),
                    onResolve: () => _resolveReport(report.id),
                  );
                },
              ),
            const SizedBox(height: 24),

            // Recent Activity section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Recent Activity', style: AppTextStyles.titleMedium),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentActivity.length,
              itemBuilder: (context, index) => RecentActivityTile(
                activity: recentActivity[index],
              ),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      ],
    );
  }
}
