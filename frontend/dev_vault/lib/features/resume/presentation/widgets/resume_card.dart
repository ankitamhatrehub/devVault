import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ResumeCard extends StatelessWidget {
  final String fileName;
  final String fileType;
  final String fileSize;
  final String uploadDate;
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;
  final VoidCallback? onReplace;
  final VoidCallback? onDelete;

  const ResumeCard({
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.uploadDate,
    this.onPreview,
    this.onDownload,
    this.onReplace,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.description_rounded,
                  size: 32,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileType,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileSize,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Uploaded $uploadDate',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // if (onPreview != null)
                //   _ActionButton(
                //     icon: Icons.visibility_outlined,
                //     label: 'Preview',
                //     onPressed: onPreview!,
                //   ),
                if (onDownload != null)
                  _ActionButton(
                    icon: Icons.download_outlined,
                    label: 'Download',
                    onPressed: onDownload!,
                  ),
                if (onReplace != null)
                  _ActionButton(
                    icon: Icons.refresh_rounded,
                    label: 'Replace',
                    onPressed: onReplace!,
                  ),
                if (onDelete != null)
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete',
                    onPressed: onDelete!,
                    isDanger: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDanger;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 20),
          color: isDanger ? AppColors.danger : AppColors.primary,
          onPressed: onPressed,
          splashRadius: 24,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDanger ? AppColors.danger : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
