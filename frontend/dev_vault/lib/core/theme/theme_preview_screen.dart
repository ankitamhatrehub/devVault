import 'package:flutter/material.dart';

import 'app_style.dart';
import 'app_theme.dart';

class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  bool switchValue = true;
  bool checkboxValue = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.extension<AppStyle>()!;
    final variant = AppTheme.currentVariant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme preview'),
        actions: [
          IconButton(
            tooltip: 'Preview bottom sheet',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bottom sheet', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    const Text('Shape, surface, and spacing come from this theme.'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            icon: const Icon(Icons.vertical_align_top),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Floating action button',
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Themed snack bar')),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: EdgeInsets.all(16 * style.spacingScale),
        children: [
          Text('Choose a theme', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(
            'Switch variants live. The permanent default is '
            '`activeThemeVariant`.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final entry in _themeNames.entries) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: entry.key == variant
                        ? FilledButton(
                            onPressed: () => _selectTheme(entry.key),
                            child: Text(entry.value),
                          )
                        : OutlinedButton(
                            onPressed: () => _selectTheme(entry.key),
                            child: Text(entry.value),
                          ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16 * style.spacingScale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Editorial hierarchy', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'A headline and supporting copy demonstrate the typography '
                    'system.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      Chip(label: Text('Design')),
                      Chip(
                        avatar: Icon(Icons.check_circle_outline, size: 18),
                        label: Text('Ready'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Input style',
              hintText: 'Outlined, filled, or underline',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated'),
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Filled'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Text'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.palette_outlined),
                  title: Text('Current style tokens'),
                  subtitle: Text('Shape, elevation, and spacing'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Card treatment: ${style.cardTreatment.name} · '
                    'input: ${style.inputStyle.name} · '
                    'density: ${style.spacingDensity.name}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Switch'),
            value: switchValue,
            onChanged: (value) => setState(() => switchValue = value),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Checkbox'),
            value: checkboxValue,
            onChanged: (value) =>
                setState(() => checkboxValue = value ?? false),
          ),
          const LinearProgressIndicator(value: 0.68),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: [
              FilledButton.tonal(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Themed dialog'),
                    content: const Text(
                      'Dialog shape, color, and typography follow the selected '
                      'theme.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Show dialog'),
              ),
              OutlinedButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => const SizedBox(
                    height: 120,
                    child: Center(child: Text('Themed bottom sheet')),
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_up),
                label: const Text('Show sheet'),
              ),
            ],
          ),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  void _selectTheme(AppThemeVariant variant) {
    AppTheme.variantNotifier.value = variant;
  }

  static const _themeNames = <AppThemeVariant, String>{
    AppThemeVariant.ocean: 'Ocean',
    AppThemeVariant.midnightNeon: 'Midnight',
    AppThemeVariant.sunsetWarm: 'Sunset',
    AppThemeVariant.forestMinimal: 'Forest',
    AppThemeVariant.monoEditorial: 'Mono',
  };
}
