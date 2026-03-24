import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Picked file
  String? _fileName;
  String? _fileSize;
  String? _fileType;

  // Format selection
  String _fromFormat = 'MP4';
  String _toFormat = 'MKV';

  // Quality
  int _selectedQuality = 0; // Original, High, Medium, Low, Custom

  // Advanced
  bool _hwAccel = true;
  bool _stripAudio = false;
  bool _customRes = false;

  bool _isConverting = false;

  static const _qualityOptions = ['Original', 'High', 'Medium', 'Low', 'Custom'];

  void _pickFile() {
    // In a real app: use file_picker package
    // FilePicker.platform.pickFiles(type: FileType.video)
    setState(() {
      _fileName = 'Nature_Documentary_4K.mp4';
      _fileSize = '1.2 GB';
      _fileType = 'MP4';
      _fromFormat = 'MP4';
    });
  }

  Future<void> _startConvert() async {
    if (_fileName == null) return;
    setState(() => _isConverting = true);
    // In a real app: call FFmpeg via flutter_ffmpeg / ffmpeg_kit_flutter
    // FFmpegKit.execute('-i input.mp4 -c:v libx264 output.mkv')
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() => _isConverting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Converted to $_toFormat successfully!'),
          backgroundColor: AppColors.surface3,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drop Zone / File Chip ─────────────────────────────
          _fileName == null
              ? _DropZone(onTap: _pickFile)
              : _FileChip(
                  name: _fileName!,
                  size: _fileSize!,
                  type: _fileType!,
                  onClear: () => setState(() => _fileName = null),
                ),
          const SizedBox(height: 16),

          if (_fileName != null) ...[
            // ── Format Selector ────────────────────────────────
            const SectionLabel('Convert From → To'),
            _FormatRow(
              from: _fromFormat,
              to: _toFormat,
              formats: convertFormats,
              onFromChanged: (v) => setState(() => _fromFormat = v),
              onToChanged: (v) => setState(() => _toFormat = v),
            ),
            const SizedBox(height: 16),

            // ── Output Quality ─────────────────────────────────
            const SectionLabel('Output Quality'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_qualityOptions.length, (i) {
                return FormatPill(
                  label: _qualityOptions[i],
                  selected: i == _selectedQuality,
                  onTap: () => setState(() => _selectedQuality = i),
                );
              }),
            ),
            const SizedBox(height: 16),

            // ── Advanced Options ───────────────────────────────
            const SectionLabel('Advanced'),
            SurfaceCard(
              child: Column(
                children: [
                  SettingsRow(
                    title: 'Hardware Acceleration',
                    subtitle: 'Use GPU for faster conversion',
                    trailing: AppToggle(
                      value: _hwAccel,
                      onChanged: (v) => setState(() => _hwAccel = v),
                    ),
                  ),
                  SettingsRow(
                    title: 'Strip Audio',
                    subtitle: 'Remove audio track from video',
                    trailing: AppToggle(
                      value: _stripAudio,
                      onChanged: (v) => setState(() => _stripAudio = v),
                    ),
                  ),
                  SettingsRow(
                    title: 'Custom Resolution',
                    subtitle: 'Override output resolution',
                    trailing: AppToggle(
                      value: _customRes,
                      onChanged: (v) => setState(() => _customRes = v),
                    ),
                    showDivider: false,
                  ),
                  if (_customRes) ...[
                    const Divider(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Width (px)',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColors.text, fontSize: 14),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('×',
                            style: TextStyle(color: AppColors.text2, fontSize: 18)),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Height (px)',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColors.text, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            GradientButton(
              label: _isConverting
                  ? 'Converting $_fromFormat → $_toFormat...'
                  : 'Start Conversion',
              icon: Icons.sync_rounded,
              isLoading: _isConverting,
              onPressed: _startConvert,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Drop Zone ────────────────────────────────────────────────────────────────

class _DropZone extends StatefulWidget {
  final VoidCallback onTap;
  const _DropZone({required this.onTap});

  @override
  State<_DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<_DropZone> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) {
        setState(() => _hovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accentGlow : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.accent : AppColors.border2,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.upload_file_rounded,
                  color: AppColors.text3, size: 28),
            ),
            const SizedBox(height: 12),
            const Text(
              'Drop file or tap to browse',
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'MP4, MKV, AVI, MOV, MP3, AAC, FLAC, WAV, WebM & more',
              style: TextStyle(fontSize: 13, color: AppColors.text3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Selected File Chip ───────────────────────────────────────────────────────

class _FileChip extends StatelessWidget {
  final String name;
  final String size;
  final String type;
  final VoidCallback onClear;

  const _FileChip({
    required this.name,
    required this.size,
    required this.type,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.movie_outlined,
                color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$type · $size',
                  style: const TextStyle(
                    fontSize: 11, color: AppColors.text3,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close_rounded, color: AppColors.text3, size: 18),
          ),
        ],
      ),
    );
  }
}

// ─── Format Row ───────────────────────────────────────────────────────────────

class _FormatRow extends StatelessWidget {
  final String from;
  final String to;
  final List<String> formats;
  final ValueChanged<String> onFromChanged;
  final ValueChanged<String> onToChanged;

  const _FormatRow({
    required this.from,
    required this.to,
    required this.formats,
    required this.onFromChanged,
    required this.onToChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _FormatDropdown(value: from, items: formats, onChanged: onFromChanged)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Icon(Icons.arrow_forward_rounded,
              color: AppColors.accent, size: 20),
        ),
        Expanded(child: _FormatDropdown(value: to, items: formats, onChanged: onToChanged)),
      ],
    );
  }
}

class _FormatDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _FormatDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.text2, size: 18),
          dropdownColor: AppColors.surface2,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
          items: items.map((f) => DropdownMenuItem(
            value: f,
            child: Text(f),
          )).toList(),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}
