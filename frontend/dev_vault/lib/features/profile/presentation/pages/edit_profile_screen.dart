import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _designationController;
  late TextEditingController _experienceController;
  late TextEditingController _locationController;
  late TextEditingController _companyController;

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isLoading = true;
  ProfileModel? _profile;

  @override
  void initState() {
    super.initState();
    print('✏️ EditProfileScreen initialized');
    print('📡 Fetching profile data from API...');

    // Initialize empty controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _designationController = TextEditingController();
    _experienceController = TextEditingController();
    _locationController = TextEditingController();
    _companyController = TextEditingController();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      print('🔄 Loading profile from API...');
      final profile = await ProfileService.getProfile();

      if (!mounted) return;

      print('✅ Profile loaded successfully');
      print('   ID: ${profile.id}');
      print('   Name: ${profile.name}');
      print('   Email: ${profile.email}');
      print('   Bio: ${profile.bio}');
      print('   Designation: ${profile.designation}');

      // Fill controllers with fetched data
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _bioController.text = profile.bio;
      _designationController.text = profile.designation;
      _experienceController.text = profile.experience;
      _locationController.text = profile.location;
      _companyController.text = profile.currentCompany;

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      print('❌ Error loading profile: $e');

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );

      // Go back if profile failed to load
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _designationController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    print('💾 Saving profile changes...');
    print('   Name: ${_nameController.text.trim()}');
    print('   Email: ${_emailController.text.trim()}');
    print('   Bio: ${_bioController.text.trim()}');
    print('   Designation: ${_designationController.text.trim()}');

    setState(() => _isSaving = true);

    try {
      await ProfileService.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        bio: _bioController.text.trim(),
        designation: _designationController.text.trim(),
        experience: _experienceController.text.trim(),
        currentCompany: _companyController.text.trim(),
        location: _locationController.text.trim(),
      );

      if (!mounted) return;

      print('✅ Profile saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green.shade600,
        ),
      );

      // Return true to indicate successful update
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      print('❌ Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            }
                            final emailRegex = RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Bio Field
                        TextFormField(
                          controller: _bioController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Bio',
                            prefixIcon: Icon(Icons.description_outlined),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Bio is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Designation Field
                        TextFormField(
                          controller: _designationController,
                          decoration: const InputDecoration(
                            labelText: 'Designation',
                            prefixIcon: Icon(Icons.work_outline_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Designation is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Experience Field
                        TextFormField(
                          controller: _experienceController,
                          decoration: const InputDecoration(
                            labelText: 'Experience',
                            prefixIcon: Icon(Icons.trending_up_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Experience is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Company Field
                        TextFormField(
                          controller: _companyController,
                          decoration: const InputDecoration(
                            labelText: 'Current Company',
                            prefixIcon: Icon(Icons.business_outlined),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Location Field
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Location is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save Changes'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
