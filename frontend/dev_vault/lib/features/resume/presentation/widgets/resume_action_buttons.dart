import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ResumeActionButtons extends StatelessWidget {
  final VoidCallback? onPreview;
  final VoidCallback? onDownload;
  final VoidCallback? onReplace;
  final VoidCallback? onDelete;

  const ResumeActionButtons({
    this.onPreview,
    this.onDownload,
    this.onReplace,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (onPreview != null)
          _ActionIconButton(
            icon: Icons.visibility_outlined,
            label: 'Preview',
            onPressed: onPreview!,
          ),
        if (onDownload != null)
          _ActionIconButton(
            icon: Icons.download_outlined,
            label: 'Download',
            onPressed: onDownload!,
          ),
        if (onReplace != null)
          _ActionIconButton(
            icon: Icons.refresh_rounded,
            label: 'Replace',
            onPressed: onReplace!,
          ),
        if (onDelete != null)
          _ActionIconButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            onPressed: onDelete!,
            isDanger: true,
          ),
      ],
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDanger;

  const _ActionIconButton({
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
          icon: Icon(icon),
          color: isDanger ? AppColors.danger : AppColors.primary,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDanger ? AppColors.danger : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
