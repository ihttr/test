import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class DownloaderScreen extends StatefulWidget {
  const DownloaderScreen({super.key});

  @override
  State<DownloaderScreen> createState() => _DownloaderScreenState();
}

class _DownloaderScreenState extends State<DownloaderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _urlController = TextEditingController();

  DownloadMode _mode = DownloadMode.video;
  bool _isFetching = false;
  VideoInfo? _videoInfo;

  int _selectedQuality = 1; // default 1080p
  int _selectedFormat = 0;  // default MP4 / MP3

  // Options
  bool _subtitles = true;
  bool _thumbnail = false;
  bool _metadata = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _mode = DownloadMode.values[_tabController.index];
          _selectedQuality = 1;
          _selectedFormat = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  List<VideoQuality> get _qualities =>
      _mode == DownloadMode.audio ? audioQualities : videoQualities;

  List<String> get _formats =>
      _mode == DownloadMode.audio ? audioFormats : videoFormats;

  Future<void> _fetchInfo() async {
    if (_urlController.text.trim().isEmpty) {
      _shakeError();
      return;
    }
    setState(() => _isFetching = true);
    // Simulate network call – replace with yt-dlp integration
    await Future.delayed(const Duration(milliseconds: 1600));
    setState(() {
      _isFetching = false;
      _videoInfo = const VideoInfo(
        title: 'How to Learn Flutter in 2024 – Complete Beginner\'s Guide',
        channel: 'TechWorld',
        views: '2.4M views',
        duration: '12:47',
        year: '2024',
        platform: 'YouTube',
      );
    });
  }

  void _shakeError() {
    HapticFeedback.mediumImpact();
    // Could drive an AnimationController to shake the input field
  }

  Future<void> _startDownload() async {
    if (_videoInfo == null) return;
    HapticFeedback.lightImpact();
    final quality = _qualities[_selectedQuality].label;
    final format  = _formats[_selectedFormat];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting download · $quality $format'),
        backgroundColor: AppColors.surface3,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Mode Tabs ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: _ModeTabs(controller: _tabController),
        ),
        // ── Scrollable body ───────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL Input
                _UrlInputCard(
                  controller: _urlController,
                  isFetching: _isFetching,
                  onFetch: _fetchInfo,
                ),
                const SizedBox(height: 16),

                // Supported platforms (only when no video loaded)
                if (_videoInfo == null) _PlatformChips(),

                // Video Info
                if (_videoInfo != null) ...[
                  _VideoPreviewCard(info: _videoInfo!),
                  const SizedBox(height: 16),

                  // Quality
                  SectionLabel(
                    _mode == DownloadMode.audio
                        ? 'Select Bitrate'
                        : 'Select Quality',
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _qualities.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.3,
                    ),
                    itemBuilder: (_, i) {
                      final q = _qualities[i];
                      return QualityChip(
                        label: q.label,
                        sublabel: q.sublabel,
                        badge: q.badge,
                        selected: i == _selectedQuality,
                        onTap: () => setState(() => _selectedQuality = i),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Format
                  const SectionLabel('Format'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_formats.length, (i) {
                      return FormatPill(
                        label: _formats[i],
                        selected: i == _selectedFormat,
                        onTap: () => setState(() => _selectedFormat = i),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // Extra options
                  SurfaceCard(
                    child: Column(
                      children: [
                        SettingsRow(
                          title: 'Subtitles',
                          subtitle: 'Embed subtitles if available',
                          trailing: AppToggle(
                            value: _subtitles,
                            onChanged: (v) => setState(() => _subtitles = v),
                          ),
                        ),
                        SettingsRow(
                          title: 'Thumbnail',
                          subtitle: 'Save thumbnail image',
                          trailing: AppToggle(
                            value: _thumbnail,
                            onChanged: (v) => setState(() => _thumbnail = v),
                          ),
                        ),
                        SettingsRow(
                          title: 'Metadata',
                          subtitle: 'Embed title, artist, year',
                          trailing: AppToggle(
                            value: _metadata,
                            onChanged: (v) => setState(() => _metadata = v),
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Download CTA
                  GradientButton(
                    label: 'Download · '
                        '${_qualities[_selectedQuality].label} '
                        '${_formats[_selectedFormat]}',
                    icon: Icons.download_rounded,
                    onPressed: _startDownload,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Mode Tabs ────────────────────────────────────────────────────────────────

class _ModeTabs extends StatelessWidget {
  final TabController controller;
  const _ModeTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.surface3,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        labelColor: AppColors.text,
        unselectedLabelColor: AppColors.text3,
        labelStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_outline, size: 14),
                SizedBox(width: 4),
                Text('Video'),
              ]),
          ),
          Tab(
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.music_note_rounded, size: 14),
                SizedBox(width: 4),
                Text('Audio'),
              ]),
          ),
          Tab(
            child: Row(mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.queue_music_rounded, size: 14),
                SizedBox(width: 4),
                Text('Playlist'),
              ]),
          ),
        ],
      ),
    );
  }
}

// ─── URL Input Card ───────────────────────────────────────────────────────────

class _UrlInputCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isFetching;
  final VoidCallback onFetch;

  const _UrlInputCard({
    required this.controller,
    required this.isFetching,
    required this.onFetch,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Paste Video URL', padding: EdgeInsets.only(bottom: 10)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: AppColors.text, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'https://youtube.com/watch?v=...',
                    prefixIcon: Icon(Icons.link_rounded, color: AppColors.text3, size: 18),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onFetch(),
                ),
              ),
              const SizedBox(width: 8),
              _PasteButton(onTap: () async {
                final data = await Clipboard.getData('text/plain');
                if (data?.text != null) controller.text = data!.text!;
              }),
            ],
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: isFetching ? 'Fetching...' : 'Fetch Video Info',
            icon: Icons.search_rounded,
            isLoading: isFetching,
            onPressed: onFetch,
          ),
        ],
      ),
    );
  }
}

class _PasteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PasteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accentGlow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.accent),
        ),
        child: const Text(
          'Paste',
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─── Platform Chips ───────────────────────────────────────────────────────────

class _PlatformChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Supported Platforms'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: supportedPlatforms.map((p) {
            final c = Color(p.color);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: c.withOpacity(0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${p.emoji} ${p.name}',
                style: TextStyle(
                  color: c,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Video Preview Card ───────────────────────────────────────────────────────

class _VideoPreviewCard extends StatelessWidget {
  final VideoInfo info;
  const _VideoPreviewCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Thumbnail
          Stack(
            children: [
              // Gradient placeholder (replace with CachedNetworkImage)
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
                  ),
                ),
              ),
              // Overlay
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xB3000000)],
                    ),
                  ),
                ),
              ),
              // Platform badge
              Positioned(
                top: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '▶ ${info.platform}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ),
              ),
              // Play button
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white, size: 28,
                    ),
                  ),
                ),
              ),
              // Duration
              Positioned(
                bottom: 10, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    info.duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SpaceGrotesk',
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Meta
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _MetaStat(Icons.person_outline_rounded, info.channel),
                    const SizedBox(width: 14),
                    _MetaStat(Icons.visibility_outlined, info.views),
                    const SizedBox(width: 14),
                    _MetaStat(Icons.calendar_today_outlined, info.year),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaStat(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.text2),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.text2)),
      ],
    );
  }
}
