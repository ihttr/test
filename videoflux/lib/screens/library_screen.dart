import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Timer? _timer;

  // Simulated active download progress
  double _activeProgress = 0.68;
  String _speed = '3.4 MB/s';

  final _completed = const [
    DownloadItem(
      id: '1',
      title: 'Top 10 UI Designs of 2024',
      quality: '720p',
      format: 'MP4',
      fileSize: '148 MB',
      status: DownloadStatus.completed,
    ),
    DownloadItem(
      id: '2',
      title: 'Lo-fi Hip Hop Chill Beats 2024',
      quality: '320kbps',
      format: 'MP3',
      isAudio: true,
      fileSize: '12 MB',
      status: DownloadStatus.completed,
    ),
    DownloadItem(
      id: '3',
      title: 'Nature: Planet Earth II Ep.3',
      quality: '1080p',
      format: 'MKV',
      fileSize: '2.1 GB',
      status: DownloadStatus.completed,
    ),
    DownloadItem(
      id: '4',
      title: 'Cyberpunk Short Film - Official Trailer',
      quality: '1080p',
      format: 'MP4',
      status: DownloadStatus.failed,
      error: 'Connection timeout',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Simulate download progress ticking
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mounted) return;
      setState(() {
        if (_activeProgress < 1.0) {
          _activeProgress = (_activeProgress + 0.02).clamp(0.0, 1.0);
          final remaining = ((1 - _activeProgress) * 47).round();
          _speed = '${(3.0 + _activeProgress).toStringAsFixed(1)} MB/s';
          if (_activeProgress >= 1.0) _speed = 'Done!';
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Active ──────────────────────────────────────────
          const SectionLabel('Active'),
          _ActiveDownloadCard(
            title: 'How to Learn Flutter in 2024 – Complete Beginner\'s Guide',
            quality: '1080p MP4',
            progress: _activeProgress,
            speed: _speed,
            eta: _activeProgress < 1.0
                ? '~${((1 - _activeProgress) * 47).round()}s left'
                : 'Complete',
          ),
          const SizedBox(height: 20),

          // ── Completed ────────────────────────────────────────
          Row(
            children: [
              const Expanded(child: SectionLabel('Completed')),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12, color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: List.generate(_completed.length, (i) {
                return _DownloadListItem(
                  item: _completed[i],
                  showDivider: i < _completed.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Active Download Card ─────────────────────────────────────────────────────

class _ActiveDownloadCard extends StatelessWidget {
  final String title;
  final String quality;
  final double progress;
  final String speed;
  final String eta;

  const _ActiveDownloadCard({
    required this.title,
    required this.quality,
    required this.progress,
    required this.speed,
    required this.eta,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$pct%',
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ProgressStat(speed),
              const Spacer(),
              _ProgressStat(quality),
              const Spacer(),
              _ProgressStat(eta),
            ],
          ),
          const SizedBox(height: 12),
          // Pause / Cancel buttons
          Row(
            children: [
              _ActionBtn(
                icon: Icons.pause_rounded,
                label: 'Pause',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.close_rounded,
                label: 'Cancel',
                onTap: () {},
                danger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  const _ProgressStat(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11, color: AppColors.text3, fontFamily: 'SpaceGrotesk',
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.red : AppColors.text2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: danger
              ? AppColors.red.withOpacity(0.1)
              : AppColors.surface2,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: danger ? AppColors.red.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Download List Item ───────────────────────────────────────────────────────

class _DownloadListItem extends StatelessWidget {
  final DownloadItem item;
  final bool showDivider;

  const _DownloadListItem({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Thumbnail placeholder
              Container(
                width: 52, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface3,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  item.isAudio
                      ? Icons.music_note_rounded
                      : Icons.movie_outlined,
                  color: item.isAudio ? AppColors.amber : AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.status == DownloadStatus.failed
                          ? 'Failed · ${item.error}'
                          : '${item.quality} · ${item.format} · ${item.fileSize ?? ''}',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'SpaceGrotesk',
                        color: item.status == DownloadStatus.failed
                            ? AppColors.red
                            : AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge
              switch (item.status) {
                DownloadStatus.completed =>
                  item.isAudio ? StatusBadge.audio() : StatusBadge.done(),
                DownloadStatus.failed => StatusBadge.error(),
                DownloadStatus.converting => StatusBadge.converting(),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        ),
        if (showDivider) const Divider(height: 0, indent: 14, endIndent: 14),
      ],
    );
  }
}
