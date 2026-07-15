import 'dart:io';
import 'package:dev_vault/data/services/resume_service.dart';
import 'package:dev_vault/data/models/resume_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import '../../../../core/theme/app_theme.dart';
import '../widgets/resume_empty_state.dart';
import '../widgets/resume_card.dart';
import '../widgets/upload_progress_card.dart';

enum ResumeState { loading, empty, uploaded, uploading }

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  late ResumeState _state = ResumeState.loading;
  double _uploadProgress = 0.0;
  ResumeModel? _resumeData;
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;
    _loadResume();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeSetState(VoidCallback callback) {
    if (!_isDisposed && mounted) {
      setState(callback);
    }
  }

  void _safeShowSnackBar(String message, {Color? bgColor}) {
    if (!_isDisposed && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bgColor ?? AppColors.danger,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadResume({bool isRetry = false}) async {
    _safeSetState(() => _state = ResumeState.loading);
    try {
      print('📡 Loading resume${isRetry ? ' (retry)' : ''}...');
      final resume = await ResumeService.getResume();
      print('✅ Resume loaded successfully: ${resume.fileName}');
      _safeSetState(() {
        _resumeData = resume;
        _state = ResumeState.uploaded;
      });
    } catch (e) {
      print('❌ Error loading resume: $e');
      print('Error type: ${e.runtimeType}');

      _safeSetState(() => _state = ResumeState.empty);

      if (isRetry && !_isDisposed && mounted) {
        _safeShowSnackBar('Failed to load resume: ${e.toString()}');
      }
    }
  }

  Future<void> _pickAndUploadResume() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickMedia();

      if (pickedFile == null) {
        print('📁 File picker cancelled by user');
        return;
      }

      // Validate file extension
      if (!pickedFile.path.toLowerCase().endsWith('.pdf')) {
        print('❌ Invalid file type: ${pickedFile.path}');
        _safeShowSnackBar('❌ Please select a PDF file');
        return;
      }

      print('📤 Starting upload for: ${pickedFile.name}');
      _safeSetState(() => _state = ResumeState.uploading);

      // Show uploading progress
      _safeSetState(() => _uploadProgress = 0.3);

      // Upload file to backend (which uploads to Cloudinary)
      final file = File(pickedFile.path);
      _safeSetState(() => _uploadProgress = 0.6);

      final resume = await ResumeService.uploadResumeFile(file);

      _safeSetState(() => _uploadProgress = 1.0);

      // Update UI with new resume
      _safeSetState(() {
        _resumeData = resume;
        _state = ResumeState.uploaded;
      });

      _safeShowSnackBar(
        '✅ Resume uploaded successfully!',
        bgColor: Colors.green,
      );
    } catch (e) {
      print('❌ Error uploading resume: $e');
      print('Error details: ${e.toString()}');
      _safeSetState(() => _state = ResumeState.empty);
      _safeShowSnackBar('Upload failed: ${e.toString()}');
    }
  }

  Future<void> _previewResume() async {
    try {
      if (_resumeData?.fileUrl == null || _resumeData!.fileUrl.isEmpty) {
        _safeShowSnackBar('Resume URL not available');
        return;
      }

      final Uri url = Uri.parse(_resumeData!.fileUrl);
      if (await url_launcher.canLaunchUrl(url)) {
        await url_launcher.launchUrl(
          url,
          mode: url_launcher.LaunchMode.externalApplication,
        );
      } else {
        _safeShowSnackBar('Could not open resume');
      }
    } catch (e) {
      print('❌ Error previewing resume: $e');
      _safeShowSnackBar('Error: ${e.toString()}');
    }
  }

  Future<void> _downloadResume() async {
    try {
      _safeSetState(() => _isLoading = true);
      final resume = await ResumeService.downloadResume();
      _safeSetState(() => _isLoading = false);
      _safeShowSnackBar(
        '📥 Downloading ${resume.fileName}...',
        bgColor: Colors.green,
      );
      await _previewResume();
    } catch (e) {
      print('❌ Error downloading resume: $e');
      _safeSetState(() => _isLoading = false);
      _safeShowSnackBar('Download failed: ${e.toString()}');
    }
  }

  void _replaceResume() {
    if (_isDisposed) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Replace Resume'),
        content: const Text('Do you want to replace your current resume?'),
        actions: [
          TextButton(
            onPressed: () {
              try {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                print('Error closing dialog: $e');
              }
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                print('Error closing dialog: $e');
              }
              _pickAndUploadResume();
            },
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  void _deleteResume() {
    if (_isDisposed) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete your resume?'),
        actions: [
          TextButton(
            onPressed: () {
              try {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                print('Error closing dialog: $e');
              }
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              } catch (e) {
                print('Error closing dialog: $e');
              }

              try {
                _safeSetState(() => _isLoading = true);
                await ResumeService.deleteResume();
                _safeSetState(() {
                  _isLoading = false;
                  _state = ResumeState.empty;
                  _resumeData = null;
                });
                _safeShowSnackBar(
                  '✅ Resume deleted successfully',
                  bgColor: Colors.green,
                );
              } catch (e) {
                print('❌ Error deleting resume: $e');
                _safeSetState(() => _isLoading = false);
                _safeShowSnackBar('Delete failed: ${e.toString()}');
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _safeGoBack() {
    try {
      if (mounted) {
        // Use GoRouter for navigation instead of Navigator
        if (context.canPop()) {
          context.pop();
        } else {
          // If can't pop, navigate to dashboard as fallback
          context.go('/dashboard');
        }
      }
    } catch (e) {
      print('Error going back: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _safeGoBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resume'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _safeGoBack,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case ResumeState.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: AppSpacing.md),
              Text('Loading your resume...'),
            ],
          ),
        );

      case ResumeState.empty:
        return ResumeEmptyState(onUpload: _pickAndUploadResume);

      case ResumeState.uploaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_resumeData != null)
              ResumeCard(
                fileName: _resumeData!.fileName,
                fileType: 'PDF',
                fileSize: _resumeData!.fileSize,
                uploadDate: _formatDate(_resumeData!.uploadedAt),
                onPreview: _isLoading ? null : _previewResume,
                onDownload: _isLoading ? null : _downloadResume,
                onReplace: _isLoading ? null : _replaceResume,
                onDelete: _isLoading ? null : _deleteResume,
              )
            else
              ResumeEmptyState(onUpload: _pickAndUploadResume),
          ],
        );

      case ResumeState.uploading:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UploadProgressCard(
                progress: _uploadProgress,
                fileName: 'Resume.pdf',
                onCancel: () {
                  setState(() => _state = ResumeState.empty);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Please wait...'),
            ],
          ),
        );
    }
  }
}
