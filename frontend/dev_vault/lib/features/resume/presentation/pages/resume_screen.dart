import 'package:dev_vault/data/services/resume_service.dart';
import 'package:flutter/material.dart';
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
  late ResumeState _state =
      ResumeState.empty; // Change to 'loading' to test loading state
  double _uploadProgress = 0.0;
  final ResumeService _resumeService = ResumeService();
  // Dummy data for testing
  String? _resumeFileName;
  String? _resumeFileSize;
  String? _resumeUploadDate;

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  Future<void> _loadResume() async {
    setState(() => _state = ResumeState.loading);
    final result = await ResumeService.getResume();

    // Simulate API call
    // await Future.delayed(const Duration(seconds: 2));

    // Uncomment to test different states
    setState(() {
      _state = ResumeState.empty; // Change to uploaded to test uploaded state
      _state = ResumeState.uploaded;
      // _resumeFileName = 'Ankita_Shelke_Resume.pdf';
      // _resumeFileSize = '1.8 MB';
      // _resumeUploadDate = '12 July 2026';
    });
  }

  Future<void> _pickAndUploadResume() async {
    setState(() => _state = ResumeState.uploading);

    // Simulate file upload progress
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _uploadProgress = i / 100);
    }

    // After upload completes
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _state = ResumeState.uploaded;
      _resumeFileName = 'Ankita_Shelke_Resume.pdf';
      _resumeFileSize = '1.8 MB';
      _resumeUploadDate = '12 July 2026';
    });
  }

  void _previewResume() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening PDF preview...')));
  }

  void _downloadResume() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Downloading resume...')));
  }

  void _replaceResume() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace Resume'),
        content: const Text('Do you want to replace your current resume?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _pickAndUploadResume();
            },
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  void _deleteResume() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Resume'),
        content: const Text('Are you sure you want to delete your resume?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _state = ResumeState.empty;
                _resumeFileName = null;
                _resumeFileSize = null;
                _resumeUploadDate = null;
              });
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _buildContent(),
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
            ResumeCard(
              fileName: _resumeFileName ?? 'Resume.pdf',
              fileType: 'PDF',
              fileSize: _resumeFileSize ?? '0 MB',
              uploadDate: _resumeUploadDate ?? 'Unknown',
              onPreview: _previewResume,
              onDownload: _downloadResume,
              onReplace: _replaceResume,
              onDelete: _deleteResume,
            ),
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
