import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/text_input.dart';
import '../widgets/bottom_nav.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _jobTitleController;
  late final TextEditingController _departmentController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameController = TextEditingController(text: state.profileName);
    _emailController = TextEditingController(text: state.profileEmail);
    _phoneController = TextEditingController(text: state.profilePhone);
    _jobTitleController = TextEditingController(text: state.profileJobTitle);
    _departmentController = TextEditingController(text: state.profileDepartment);
    _locationController = TextEditingController(text: state.profileLocation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _departmentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final state = context.read<AppState>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final bytes = result.files.first.bytes;
    if (bytes == null || bytes.isEmpty) return;

    await state.setProfilePhotoBase64(base64Encode(bytes));
  }

  Future<void> _saveProfile() async {
    final state = context.read<AppState>();
    await state.saveProfileInfo(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      jobTitle: _jobTitleController.text,
      department: _departmentController.text,
      location: _locationController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile changes saved.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final avatarBytes = state.profilePhotoBase64;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: state.headerColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile Information',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF3B82F6),
                    backgroundImage: avatarBytes != null && avatarBytes.isNotEmpty
                        ? MemoryImage(base64Decode(avatarBytes))
                        : null,
                    child: avatarBytes == null || avatarBytes.isEmpty
                        ? Text(
                            _getInitials(user.name),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: _changePhoto,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Change Photo',
                          style: GoogleFonts.inter(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (avatarBytes != null && avatarBytes.isNotEmpty)
                        OutlinedButton(
                          onPressed: () => state.setProfilePhotoBase64(null),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Remove Photo',
                            style: GoogleFonts.inter(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildInfoField(
              'Full Name',
              _nameController,
              LucideIcons.userRound,
            ),
            _buildInfoField('Email', _emailController, LucideIcons.mail),
            _buildInfoField('Phone', _phoneController, LucideIcons.phone),
            _buildInfoField(
              'Job Title',
              _jobTitleController,
              LucideIcons.briefcaseBusiness,
            ),
            _buildInfoField(
              'Department',
              _departmentController,
              LucideIcons.building,
            ),
            _buildInfoField(
              'Location',
              _locationController,
              LucideIcons.mapPin,
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2181FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppTextInput(
            controller: controller,
            filled: true,
            fillColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
