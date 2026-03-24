# VideoFlux 🎬

A modern Flutter Android app for downloading videos and converting media files.
Built with Material You design, dark AMOLED theme, and powerful yt-dlp + FFmpeg backend.

---

## Features

- **Video Downloader** — YouTube, Vimeo, TikTok, Instagram, Twitter, Reddit
- **Quality Selection** — 4K / 1080p / 720p / 480p / 360p / Auto
- **Audio Extraction** — MP3, AAC, FLAC, WAV, OGG at 320/256/192/128 kbps
- **Playlist Downloads** — Batch download entire playlists
- **File Converter** — Convert between MP4, MKV, AVI, MOV, WebM, MP3, AAC, FLAC, WAV
- **Background Downloads** — Continue downloading with app minimized
- **Download Library** — Progress tracking, pause/resume/cancel, history
- **Settings** — Quality defaults, WiFi-only, concurrent downloads, accent colors

---

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── theme/
│   └── app_theme.dart           # Colors, typography, ThemeData
├── models/
│   └── models.dart              # VideoInfo, DownloadItem, Quality, etc.
├── widgets/
│   └── widgets.dart             # GradientButton, QualityChip, FormatPill,
│                                #   AppToggle, SurfaceCard, StatusBadge, etc.
└── screens/
    ├── home_screen.dart         # Root scaffold + bottom navigation
    ├── downloader_screen.dart   # URL input, video info, quality picker
    ├── converter_screen.dart    # File picker + format converter
    ├── library_screen.dart      # Active + completed downloads
    └── settings_screen.dart     # All app settings
```

---

## Setup

### 1. Install Flutter
```bash
flutter --version   # Requires Flutter 3.19+
```

### 2. Add fonts
Download from Google Fonts and place in `assets/fonts/`:
- [DM Sans](https://fonts.google.com/specimen/DM+Sans)
- [Space Grotesk](https://fonts.google.com/specimen/Space+Grotesk)

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run on device
```bash
flutter run --release
```

---

## Backend Integration

### yt-dlp (Video Downloading)

VideoFlux uses **yt-dlp** as the download engine. You have two integration options:

#### Option A — Local yt-dlp server (recommended)
Run a small Python server on the same device via Termux, or bundle a Dart HTTP
server that shells out to yt-dlp. Example flow:

```dart
// In downloader_screen.dart — replace the simulated delay with:
final response = await http.post(
  Uri.parse('http://localhost:8080/info'),
  body: jsonEncode({'url': urlController.text}),
  headers: {'Content-Type': 'application/json'},
);
final data = jsonDecode(response.body);
setState(() {
  _videoInfo = VideoInfo(
    title:    data['title'],
    channel:  data['uploader'],
    views:    data['view_count'].toString(),
    duration: _formatDuration(data['duration']),
    year:     data['upload_date'].substring(0, 4),
    platform: data['extractor_key'],
    thumbnailUrl: data['thumbnail'],
  );
});
```

#### Option B — cobalt.tools API (no server needed)
Use the [cobalt.tools](https://cobalt.tools) public API for quick prototyping:

```dart
final res = await http.post(
  Uri.parse('https://api.cobalt.tools/'),
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'url': url,
    'vQuality': '1080',
    'filenameStyle': 'pretty',
  }),
);
```

---

### FFmpeg (File Conversion)

Uses `ffmpeg_kit_flutter`. Replace the simulated delay in `converter_screen.dart`:

```dart
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

Future<void> _startConvert() async {
  final inputPath  = '/storage/emulated/0/Download/$_fileName';
  final outputPath = '/storage/emulated/0/Download/VideoFlux/'
      '${_fileName!.split('.').first}.${ _toFormat.toLowerCase()}';

  final session = await FFmpegKit.execute(
    '-i "$inputPath" '
    '${_hwAccel ? "-hwaccel auto " : ""}'
    '${_stripAudio ? "-an " : ""}'
    '${_customRes ? "-vf scale=$_width:$_height " : ""}'
    '-c:v libx264 -preset fast -crf 22 '
    '-c:a aac -b:a 192k '
    '"$outputPath"',
  );

  final returnCode = await session.getReturnCode();
  if (ReturnCode.isSuccess(returnCode)) {
    // Show success
  } else {
    final logs = await session.getAllLogsAsString();
    // Show error with logs
  }
}
```

---

### Background Downloads

Configure `flutter_downloader` in `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: false);
  runApp(const VideoFluxApp());
}

// Start a download:
final taskId = await FlutterDownloader.enqueue(
  url: downloadUrl,
  savedDir: saveDir,
  fileName: '$title.mp4',
  showNotification: true,
  openFileFromNotification: true,
);

// Listen to progress:
FlutterDownloader.registerCallback(downloadCallback);

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  IsolateNameServer.lookupPortByName('downloader_send_port')
      ?.send([id, status, progress]);
}
```

---

## State Management

The app uses `provider` for simplicity. For larger scale, switch to Riverpod:

```dart
// Create a DownloadProvider:
class DownloadProvider extends ChangeNotifier {
  final List<DownloadItem> _items = [];
  List<DownloadItem> get items => _items;

  void addDownload(DownloadItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateProgress(String id, double progress) {
    final i = _items.indexWhere((d) => d.id == id);
    if (i != -1) {
      _items[i] = _items[i].copyWith(progress: progress);
      notifyListeners();
    }
  }
}

// Wrap app:
ChangeNotifierProvider(
  create: (_) => DownloadProvider(),
  child: const VideoFluxApp(),
)
```

---

## Build Release APK

```bash
# Generate signing key
keytool -genkey -v -keystore ~/videoflux.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias videoflux

# Build fat APK (all ABIs)
flutter build apk --release

# Build split APKs (smaller, recommended)
flutter build apk --split-per-abi --release

# Output: build/app/outputs/flutter-apk/
```

---

## Recommended Packages Summary

| Purpose | Package |
|---|---|
| Video downloading | yt-dlp (via HTTP server or Termux) |
| File conversion | `ffmpeg_kit_flutter` |
| Background downloads | `flutter_downloader` |
| File picker | `file_picker` |
| Image caching | `cached_network_image` |
| Notifications | `flutter_local_notifications` |
| State management | `provider` or `riverpod` |
| Local DB | `hive_flutter` |
| Permissions | `permission_handler` |
| Storage paths | `path_provider` |

---

## License
MIT — free to use and modify.
