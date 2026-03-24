import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _defaultQuality = '1080p';
  String _downloadPath = '/storage/Downloads/VideoFlux';
  int _concurrentDownloads = 3;
  bool _wifiOnly = true;
  bool _darkMode = true;
  bool _notifications = true;
  bool _autoConvert = false;
  int _selectedAccent = 0;
  double _storageUsed = 3.4;
  double _storageTotal = 10.0;

  static const _accentColors = [
    Color(0xFF7C6FF7),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF00B2FF),
  ];

  static const _qualityOptions = ['2160p', '1080p', '720p', '480p', 'Auto'];
  static const _concurrentOptions = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Download Settings ────────────────────────────────
          const SectionLabel('Download Settings'),
          SurfaceCard(
            child: Column(
              children: [
                SettingsRow(
                  title: 'Default Quality',
                  subtitle: 'Auto-select when fetching',
                  trailing: _DropdownValue(
                    value: _defaultQuality,
                    items: _qualityOptions,
                    onChanged: (v) => setState(() => _defaultQuality = v),
                  ),
                ),
                SettingsRow(
                  title: 'Download Location',
                  subtitle: _downloadPath,
                  trailing: GestureDetector(
                    onTap: _pickDirectory,
                    child: const Icon(Icons.edit_outlined,
                        color: AppColors.accent, size: 18),
                  ),
                ),
                SettingsRow(
                  title: 'Concurrent Downloads',
                  subtitle: 'Max simultaneous',
                  trailing: _DropdownValue(
                    value: _concurrentDownloads.toString(),
                    items: _concurrentOptions.map((e) => e.toString()).toList(),
                    onChanged: (v) =>
                        setState(() => _concurrentDownloads = int.parse(v)),
                  ),
                ),
                SettingsRow(
                  title: 'WiFi Only',
                  subtitle: 'Pause on mobile data',
                  trailing: AppToggle(
                    value: _wifiOnly,
                    onChanged: (v) => setState(() => _wifiOnly = v),
                  ),
                ),
                SettingsRow(
                  title: 'Auto-Convert After Download',
                  subtitle: 'Convert to preferred format',
                  trailing: AppToggle(
                    value: _autoConvert,
                    onChanged: (v) => setState(() => _autoConvert = v),
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Appearance ───────────────────────────────────────
          const SectionLabel('Appearance'),
          SurfaceCard(
            child: Column(
              children: [
                SettingsRow(
                  title: 'Dark Mode',
                  subtitle: 'AMOLED dark theme',
                  trailing: AppToggle(
                    value: _darkMode,
                    onChanged: (v) => setState(() => _darkMode = v),
                  ),
                ),
                SettingsRow(
                  title: 'Accent Color',
                  subtitle: 'App theme color',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_accentColors.length, (i) {
                      final selected = i == _selectedAccent;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAccent = i),
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: _accentColors[i],
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(color: Colors.white, width: 2)
                                : null,
                          ),
                          child: selected
                              ? const Icon(Icons.check,
                                  size: 12, color: Colors.white)
                              : null,
                        ),
                      );
                    }),
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Notifications ────────────────────────────────────
          const SectionLabel('Notifications'),
          SurfaceCard(
            child: SettingsRow(
              title: 'Download Notifications',
              subtitle: 'Notify on completion or error',
              trailing: AppToggle(
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              showDivider: false,
            ),
          ),
          const SizedBox(height: 20),

          // ── Storage ──────────────────────────────────────────
          const SectionLabel('Storage'),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Used Storage',
                      style: TextStyle(fontSize: 14, color: AppColors.text)),
                    Text(
                      '${_storageUsed.toStringAsFixed(1)} GB of '
                      '${_storageTotal.toStringAsFixed(0)} GB',
                      style: const TextStyle(
                        fontSize: 12, color: AppColors.text3,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: _storageUsed / _storageTotal,
                    backgroundColor: AppColors.surface3,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    minHeight: 6,
                  ),
                ),
                const Divider(height: 20),
                SettingsRow(
                  title: 'Clear Cache',
                  subtitle: 'Free up temporary files',
                  trailing: GestureDetector(
                    onTap: _clearCache,
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 13, color: AppColors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                  ),
                ),
                SettingsRow(
                  title: 'Delete All Downloads',
                  subtitle: 'Remove all saved files',
                  trailing: GestureDetector(
                    onTap: _confirmDeleteAll,
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 13, color: AppColors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                  ),
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── About ────────────────────────────────────────────
          const SectionLabel('About'),
          SurfaceCard(
            child: Column(
              children: [
                _AboutRow(title: 'Version', value: '2.4.1'),
                _AboutRow(title: 'Built with', value: 'Flutter 3.24'),
                _AboutRow(title: 'Backend', value: 'yt-dlp + FFmpeg'),
                _AboutRow(
                  title: 'Licenses',
                  value: '',
                  trailing: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.text3),
                  onTap: () {},
                  showDivider: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Center(
            child: Column(
              children: const [
                Text(
                  'VideoFlux v2.4.1',
                  style: TextStyle(
                    fontSize: 12, color: AppColors.text3,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Open source · MIT License',
                  style: TextStyle(fontSize: 11, color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickDirectory() {
    // In a real app: use path_provider + permission_handler
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Directory picker — integrate with path_provider'),
        backgroundColor: AppColors.surface3,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearCache() {
    setState(() => _storageUsed = (_storageUsed - 0.4).clamp(0, _storageTotal));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared — 400 MB freed'),
        backgroundColor: AppColors.surface3,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmDeleteAll() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface2,
        title: const Text('Delete all downloads?',
            style: TextStyle(color: AppColors.text, fontSize: 16)),
        content: const Text(
          'This will permanently delete all saved files.',
          style: TextStyle(color: AppColors.text2, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.text2)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _storageUsed = 0.0);
            },
            child: const Text('Delete',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── About Row ────────────────────────────────────────────────────────────────

class _AboutRow extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const _AboutRow({
    required this.title,
    required this.value,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      title: title,
      trailing: trailing ??
          Text(
            value,
            style: const TextStyle(
              fontSize: 13, color: AppColors.text2,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
      showDivider: showDivider,
    );
  }
}

// ─── Dropdown Value ───────────────────────────────────────────────────────────

class _DropdownValue extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownValue({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.accent, size: 16),
          dropdownColor: AppColors.surface2,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}
