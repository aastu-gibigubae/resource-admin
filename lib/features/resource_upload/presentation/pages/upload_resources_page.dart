import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';

const _navy = Color(0xFF0D2B6E);

class UploadResourcesPage extends ConsumerStatefulWidget {
  const UploadResourcesPage({super.key});

  @override
  ConsumerState<UploadResourcesPage> createState() =>
      _UploadResourcesPageState();
}

class _UploadResourcesPageState extends ConsumerState<UploadResourcesPage> {
  final _titleController = TextEditingController();
  String? _selectedStream;
  String? _selectedDepartment;
  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedCategory;
  bool _isUploading = false;

  final _streams = ['Natural Science', 'Social Science'];
  final _departments = ['Engineering', 'Applied Science', 'Business', 'Medicine'];
  final _courses = ['Mathematics', 'Physics', 'Chemistry', 'Biology'];
  final _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final _categories = ['Lecture Note', 'Past Exam', 'Textbook', 'Other'];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onUpload() async {
    setState(() => _isUploading = true);
    try {
      // TODO: use file_picker to pick file and POST to /admin/resources
      // For now shows success after delay
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resource uploaded successfully!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: _navy,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(RouteNames.dashboard),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload Resources',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Add new resources to the system',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Form fields grid ──
            Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  // Row 1: Resource Title + Stream
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          label: 'Resource Title',
                          child: TextFormField(
                            controller: _titleController,
                            style: const TextStyle(fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'eg. Psychology',
                              hintStyle: TextStyle(
                                  color: Color(0xFFAAAAAA), fontSize: 13),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide:
                                    BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(color: _navy),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _FormField(
                          label: 'Stream',
                          child: _DropdownField(
                            hint: 'Select Stream',
                            value: _selectedStream,
                            items: _streams,
                            onChanged: (v) =>
                                setState(() => _selectedStream = v),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Row 2: Department + Course
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          label: 'Department',
                          child: _DropdownField(
                            hint: 'Select Department',
                            value: _selectedDepartment,
                            items: _departments,
                            onChanged: (v) =>
                                setState(() => _selectedDepartment = v),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _FormField(
                          label: 'Course',
                          child: _DropdownField(
                            hint: 'Select Course',
                            value: _selectedCourse,
                            items: _courses,
                            onChanged: (v) =>
                                setState(() => _selectedCourse = v),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Row 3: Academic Year + Category
                  Row(
                    children: [
                      Expanded(
                        child: _FormField(
                          label: 'Academic Year',
                          child: _DropdownField(
                            hint: 'Select Year',
                            value: _selectedYear,
                            items: _years,
                            onChanged: (v) =>
                                setState(() => _selectedYear = v),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _FormField(
                          label: 'Category',
                          child: _DropdownField(
                            hint: 'Select Category',
                            value: _selectedCategory,
                            items: _categories,
                            onChanged: (v) =>
                                setState(() => _selectedCategory = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── File upload area ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDDDDDD),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upload cloud icon
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Drag or drop file here or tap browse',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PDF, JPG, PNG, DOCX – Max 15MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Upload & Publish button ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _onUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Upload & Publish',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

// ─── Form field wrapper ───────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _navy,
          ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

// ─── Dropdown field ───────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint,
              style: const TextStyle(
                  color: Color(0xFFAAAAAA), fontSize: 13)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF888888), size: 20),
          style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
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
                icon: Icons.home_outlined,
                label: 'Home',
                active: false,
                onTap: () => context.go(RouteNames.dashboard),
              ),
              _NavItem(
                icon: Icons.people_outline_rounded,
                label: 'Users',
                active: false,
                onTap: () => context.go(RouteNames.userManagement),
              ),
              _NavItem(
                icon: Icons.folder_open_rounded,
                label: 'Resources',
                active: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                active: false,
                onTap: () => context.go(RouteNames.profile),
              ),
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
