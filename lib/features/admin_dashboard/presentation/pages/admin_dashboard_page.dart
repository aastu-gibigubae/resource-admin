import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/pending_request_model.dart';
import '../../data/models/recent_activity_model.dart';
import '../../providers/dashboard_provider.dart';

const _navy = Color(0xFF0D2B6E);
const _amber = Color(0xFFF9A825);
const _greenDark = Color(0xFF2E7D32);
const _redOutline = Color(0xFFD32F2F);
const _avatarBg = Color(0xFFE8EAF6);
const _cardBorder = Color(0xFFE0E0E0);

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const _BottomNav(),
      body: state.when(
        loading: () => const _Body(isLoading: true),
        error: (e, _) => _Body(
          isLoading: false,
          error: e.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (d) => _Body(
          isLoading: false,
          stats: d.stats,
          pendingRequests: d.pendingRequests,
          recentActivity: d.recentActivity,
        ),
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends ConsumerStatefulWidget {
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final DashboardStatsModel? stats;
  final List<PendingRequestModel>? pendingRequests;
  final List<RecentActivityModel>? recentActivity;

  const _Body({
    required this.isLoading,
    this.error,
    this.onRetry,
    this.stats,
    this.pendingRequests,
    this.recentActivity,
  });

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final Set<int> _approving = {};
  final Set<int> _rejecting = {};

  Future<void> _approve(int id) async {
    setState(() => _approving.add(id));
    try {
      await ref.read(dashboardProvider.notifier).approveRequest(id);
    } finally {
      if (mounted) setState(() => _approving.remove(id));
    }
  }

  Future<void> _reject(int id) async {
    setState(() => _rejecting.add(id));
    try {
      await ref.read(dashboardProvider.notifier).rejectRequest(id);
    } finally {
      if (mounted) setState(() => _rejecting.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: widget.onRetry, child: const Text('Retry')),
        ]),
      );
    }

    final topPadding = MediaQuery.of(context).padding.top;
    final stats = widget.stats ?? DashboardStatsModel.mock();
    final pending = widget.pendingRequests ?? PendingRequestModel.mockList();
    final activity = widget.recentActivity ?? RecentActivityModel.mockList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Navy header ──
          Container(
            decoration: const BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.person_add_alt_1_outlined,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Overview of payment requests and subscription\nstatus.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Cards inside navy, overlapping bottom ──
                Transform.translate(
                  offset: const Offset(0, 30),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _StatCard(
                            bgColor: const Color(0xFFF1F6FF),
                            border: Border.all(color: const Color(0xFFD0E1FF)),
                            iconWidget: const Icon(Icons.people,
                                color: Color(0xFF1565C0), size: 24),
                            label: 'Total students',
                            labelColor: const Color(0xFF1565C0),
                            value: widget.isLoading
                                ? '...'
                                : stats.totalStudents.toString(),
                            valueColor: _navy,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            bgColor: const Color(0xFFE8F5E9),
                            iconWidget: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA5D6A7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            label: 'Active\nSubscriptions',
                            labelColor: const Color(0xFF2E7D32),
                            value: widget.isLoading
                                ? '...'
                                : stats.activeSubscriptions.toString(),
                            valueColor: const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            bgColor: const Color(0xFFDCEEFB),
                            iconWidget: const Icon(Icons.folder,
                                color: Color(0xFF1565C0), size: 24),
                            label: 'Resource\nUploaded',
                            labelColor: const Color(0xFF1565C0),
                            value: widget.isLoading
                                ? '...'
                                : stats.resourceUploaded.toString(),
                            valueColor: _navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Pending Payment Requests ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Payment Requests',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go(RouteNames.pendingRequests),
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          if (widget.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: _navy),
              ),
            )
          else if (pending.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text('No pending requests',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            ...pending.take(5).map((r) => _PendingCard(
                  request: r,
                  isApproving: _approving.contains(r.id),
                  isRejecting: _rejecting.contains(r.id),
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
                color: _navy,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              children: activity.asMap().entries.map((e) {
                return Column(children: [
                  _ActivityRow(activity: e.value),
                  if (e.key < activity.length - 1)
                    const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFEEEEEE)),
                ]);
              }).toList(),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final Color bgColor;
  final Border? border;
  final Widget iconWidget;
  final String label;
  final Color labelColor;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.bgColor,
    this.border,
    required this.iconWidget,
    required this.label,
    required this.labelColor,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                  height: 1.3)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                  height: 1.1)),
        ],
      ),
    );
  }
}

// ─── Pending request card ─────────────────────────────────────────────────────

class _PendingCard extends StatelessWidget {
  final PendingRequestModel request;
  final bool isApproving;
  final bool isRejecting;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingCard({
    required this.request,
    required this.isApproving,
    required this.isRejecting,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final busy = isApproving || isRejecting;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(request.initials,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _navy)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.studentName,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _navy)),
                    Text(request.email,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF777777))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: _amber),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Pending',
                    style: TextStyle(
                        fontSize: 11,
                        color: _amber,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Ref: ${request.refNumber}  •  Amount: ${request.amount}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
          const SizedBox(height: 2),
          Text('Submitted: ${request.submittedAt}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: busy ? null : onApprove,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _greenDark,
                      side: const BorderSide(color: _greenDark),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                    child: isApproving
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _greenDark))
                        : const Text('Approve Access',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: busy ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _redOutline,
                      side: const BorderSide(color: _redOutline),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                    ),
                    child: isRejecting
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: _redOutline))
                        : const Text('Reject',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Activity row ─────────────────────────────────────────────────────────────

class _ActivityRow extends StatelessWidget {
  final RecentActivityModel activity;

  const _ActivityRow({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            activity.type == 'upload'
                ? Icons.upload_rounded
                : Icons.check_circle_outline_rounded,
            size: 18,
            color: const Color(0xFF666666),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(activity.description,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222222))),
          ),
          const SizedBox(width: 10),
          Text(activity.timeAgo,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888))),
        ],
      ),
    );
  }
}

// ─── Bottom navigation ────────────────────────────────────────────────────────

class _BottomNav extends ConsumerWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                  icon: Icons.home_filled,
                  label: 'Home',
                  active: true,
                  onTap: () => context.go(RouteNames.dashboard)),
              _NavItem(
                  icon: Icons.people_outline_rounded,
                  label: 'Users',
                  active: false,
                  onTap: () => context.go(RouteNames.userManagement)),
              _NavItem(
                  icon: Icons.folder_outlined,
                  label: 'Resources',
                  active: false,
                  onTap: () => context.go(RouteNames.uploadResources)),
              _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  active: false,
                  onTap: () => context.go(RouteNames.profile)),
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
    final color = active ? _navy : const Color(0xFF9E9E9E);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight:
                        active ? FontWeight.w700 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
