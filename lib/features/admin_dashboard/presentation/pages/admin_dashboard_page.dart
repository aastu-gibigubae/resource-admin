import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/pending_request_model.dart';
import '../../data/models/recent_activity_model.dart';
import '../../providers/dashboard_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: state.when(
        loading: () => const _DashboardContent(isLoading: true),
        error: (e, _) => _DashboardContent(
          isLoading: false,
          error: e.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (data) => _DashboardContent(
          isLoading: false,
          stats: data.stats,
          pendingRequests: data.pendingRequests,
          recentActivity: data.recentActivity,
        ),
      ),
      bottomNavigationBar: _BottomNav(
        onTap: (i) {
          switch (i) {
            case 0:
              context.go(RouteNames.dashboard);
            case 1:
              context.go(RouteNames.userManagement);
            case 2:
              context.go(RouteNames.uploadResources);
            case 3:
              context.go(RouteNames.profile);
          }
        },
      ),
    );
  }
}

// ─── Main scrollable content ──────────────────────────────────────────────────

class _DashboardContent extends ConsumerStatefulWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final DashboardStatsModel? stats;
  final List<PendingRequestModel>? pendingRequests;
  final List<RecentActivityModel>? recentActivity;

  const _DashboardContent({
    required this.isLoading,
    this.error,
    this.onRetry,
    this.stats,
    this.pendingRequests,
    this.recentActivity,
  });

  @override
  ConsumerState<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends ConsumerState<_DashboardContent> {
  final Set<int> _approvingIds = {};
  final Set<int> _rejectingIds = {};

  Future<void> _approve(int id) async {
    setState(() => _approvingIds.add(id));
    try {
      await ref.read(dashboardProvider.notifier).approveRequest(id);
    } finally {
      if (mounted) setState(() => _approvingIds.remove(id));
    }
  }

  Future<void> _reject(int id) async {
    setState(() => _rejectingIds.add(id));
    try {
      await ref.read(dashboardProvider.notifier).rejectRequest(id);
    } finally {
      if (mounted) setState(() => _rejectingIds.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats ?? DashboardStatsModel.mock();
    final pending = widget.pendingRequests ?? PendingRequestModel.mockList();
    final activity = widget.recentActivity ?? RecentActivityModel.mockList();

    return CustomScrollView(
      slivers: [
        // ── Dark navy app bar ──
        SliverAppBar(
          expandedHeight: 130,
          pinned: true,
          backgroundColor: AppColors.primaryDark,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined, color: Colors.white),
              onPressed: () {},
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.primaryDark,
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Overview of payment requests and subscription\nstatus.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stat cards ──
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people,
                        iconBg: const Color(0xFF1565C0),
                        iconColor: Colors.white,
                        label: 'Total students',
                        value: widget.isLoading ? '...' : stats.totalStudents.toString(),
                        cardBg: const Color(0xFF1565C0),
                        labelColor: Colors.white70,
                        valueColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle_outline,
                        iconBg: const Color(0xFFE8F5E9),
                        iconColor: const Color(0xFF2E7D32),
                        label: 'Active Subscriptions',
                        value: widget.isLoading ? '...' : stats.activeSubscriptions.toString(),
                        cardBg: const Color(0xFFE8F5E9),
                        labelColor: const Color(0xFF2E7D32),
                        valueColor: const Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.folder_outlined,
                        iconBg: const Color(0xFFE3F2FD),
                        iconColor: const Color(0xFF1565C0),
                        label: 'Resource Uploaded',
                        value: widget.isLoading ? '...' : stats.resourceUploaded.toString(),
                        cardBg: const Color(0xFFE3F2FD),
                        labelColor: const Color(0xFF1565C0),
                        valueColor: const Color(0xFF0D47A1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Pending Payment Requests header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Pending Payment Requests',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.pendingRequests),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── Pending request cards ──
              if (pending.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('No pending requests',
                      style: TextStyle(color: Colors.grey)),
                )
              else
                ...pending.take(5).map((r) => _PendingRequestCard(
                      request: r,
                      isApproving: _approvingIds.contains(r.id),
                      isRejecting: _rejectingIds.contains(r.id),
                      onApprove: () => _approve(r.id),
                      onReject: () => _reject(r.id),
                    )),

              const SizedBox(height: 20),

              // ── Recent Activity ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Column(
                  children: activity.asMap().entries.map((entry) {
                    final i = entry.key;
                    final a = entry.value;
                    return Column(
                      children: [
                        _ActivityTile(activity: a),
                        if (i < activity.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color cardBg;
  final Color labelColor;
  final Color valueColor;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.cardBg,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg == cardBg
                  ? Colors.white.withValues(alpha: 0.2)
                  : iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pending request card ─────────────────────────────────────────────────────

class _PendingRequestCard extends StatelessWidget {
  final PendingRequestModel request;
  final bool isApproving;
  final bool isRejecting;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingRequestCard({
    required this.request,
    required this.isApproving,
    required this.isRejecting,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Initials avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    request.initials,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.studentName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      request.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              // Pending badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accent),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Ref: ${request.refNumber}  •  Amount: ${request.amount}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
          Text(
            'Submitted: ${request.submittedAt}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Approve button
              Expanded(
                child: OutlinedButton(
                  onPressed: (isApproving || isRejecting) ? null : onApprove,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: isApproving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF2E7D32)),
                        )
                      : const Text('Approve Access',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              // Reject button
              Expanded(
                child: OutlinedButton(
                  onPressed: (isApproving || isRejecting) ? null : onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    side: const BorderSide(color: Color(0xFFD32F2F)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: isRejecting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFFD32F2F)),
                        )
                      : const Text('Reject',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Activity tile ────────────────────────────────────────────────────────────

class _ActivityTile extends StatelessWidget {
  final RecentActivityModel activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isUpload = activity.type == 'upload';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(
            isUpload ? Icons.upload_outlined : Icons.check_circle_outline,
            size: 18,
            color: const Color(0xFF888888),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              activity.description,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            activity.timeAgo,
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom navigation ────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final void Function(int) onTap;

  const _BottomNav({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home, label: 'Home', active: true, onTap: () => onTap(0)),
              _NavItem(icon: Icons.people_outline, label: 'Users', active: false, onTap: () => onTap(1)),
              _NavItem(icon: Icons.folder_outlined, label: 'Resources', active: false, onTap: () => onTap(2)),
              _NavItem(icon: Icons.person_outline, label: 'Profile', active: false, onTap: () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryDark : const Color(0xFF9E9E9E);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400)),
        ],
      ),
    );
  }
}
