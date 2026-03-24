// ─── Video Quality ───────────────────────────────────────────────────────────

enum DownloadMode { video, audio, playlist }

class VideoQuality {
  final String label;   // "1080p", "320"
  final String sublabel; // "Full HD", "kbps"
  final String? badge;  // "4K", "HQ"

  const VideoQuality({required this.label, required this.sublabel, this.badge});
}

const videoQualities = [
  VideoQuality(label: '2160p', sublabel: '4K UHD', badge: '4K'),
  VideoQuality(label: '1080p', sublabel: 'Full HD'),
  VideoQuality(label: '720p',  sublabel: 'HD'),
  VideoQuality(label: '480p',  sublabel: 'SD'),
  VideoQuality(label: '360p',  sublabel: 'Low'),
  VideoQuality(label: 'Auto',  sublabel: 'Adaptive'),
];

const audioQualities = [
  VideoQuality(label: '320', sublabel: 'kbps', badge: 'HQ'),
  VideoQuality(label: '256', sublabel: 'kbps'),
  VideoQuality(label: '192', sublabel: 'kbps'),
  VideoQuality(label: '128', sublabel: 'kbps'),
  VideoQuality(label: '96',  sublabel: 'kbps'),
  VideoQuality(label: 'Auto', sublabel: 'Best'),
];

const videoFormats = ['MP4', 'MKV', 'WebM', 'AVI', 'MOV'];
const audioFormats = ['MP3', 'AAC', 'FLAC', 'WAV', 'OGG'];
const convertFormats = ['MP4', 'MKV', 'AVI', 'MOV', 'WebM', 'MP3', 'AAC', 'FLAC', 'WAV'];

// ─── Video Info ───────────────────────────────────────────────────────────────

class VideoInfo {
  final String title;
  final String channel;
  final String views;
  final String duration;
  final String year;
  final String platform;
  final String? thumbnailUrl;

  const VideoInfo({
    required this.title,
    required this.channel,
    required this.views,
    required this.duration,
    required this.year,
    required this.platform,
    this.thumbnailUrl,
  });
}

// ─── Download Item ────────────────────────────────────────────────────────────

enum DownloadStatus { downloading, completed, failed, converting }

class DownloadItem {
  final String id;
  final String title;
  final String quality;
  final String format;
  final bool isAudio;
  final DownloadStatus status;
  final double progress;   // 0.0 – 1.0
  final String? speed;     // "3.4 MB/s"
  final String? eta;       // "~47s left"
  final String? fileSize;  // "148 MB"
  final String? error;

  const DownloadItem({
    required this.id,
    required this.title,
    required this.quality,
    required this.format,
    this.isAudio = false,
    required this.status,
    this.progress = 0.0,
    this.speed,
    this.eta,
    this.fileSize,
    this.error,
  });

  DownloadItem copyWith({
    double? progress,
    DownloadStatus? status,
    String? speed,
    String? eta,
  }) {
    return DownloadItem(
      id: id,
      title: title,
      quality: quality,
      format: format,
      isAudio: isAudio,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      speed: speed ?? this.speed,
      eta: eta ?? this.eta,
      fileSize: fileSize,
      error: error,
    );
  }
}

// ─── Platform ─────────────────────────────────────────────────────────────────

class SupportedPlatform {
  final String name;
  final String emoji;
  final int color; // as int for Color(0xFF...)

  const SupportedPlatform(this.name, this.emoji, this.color);
}

const supportedPlatforms = [
  SupportedPlatform('YouTube',   '▶', 0xFFFF0000),
  SupportedPlatform('Vimeo',     '▪', 0xFF00B2FF),
  SupportedPlatform('TikTok',    '♪', 0xFFFF0068),
  SupportedPlatform('Instagram', '◈', 0xFFE040FB),
  SupportedPlatform('Twitter',   '𝕏', 0xFF1DA1F2),
  SupportedPlatform('Reddit',    '●', 0xFFFF4500),
];
