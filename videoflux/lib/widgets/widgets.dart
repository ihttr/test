import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Gradient Button ──────────────────────────────────────────────────────────

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween(begin: 1.0, end: 0.97).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 18),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─── Surface Card ─────────────────────────────────────────────────────────────

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: child,
    );
  }
}

// ─── Quality Chip ─────────────────────────────────────────────────────────────

class QualityChip extends StatelessWidget {
  final String label;
  final String sublabel;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const QualityChip({
    super.key,
    required this.label,
    required this.sublabel,
    this.badge,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGlow : AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.accent : AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: const TextStyle(fontSize: 10, color: AppColors.text3),
            ),
            if (badge != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: Colors.white, fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Format Pill ──────────────────────────────────────────────────────────────

class FormatPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FormatPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentGlow : AppColors.surface2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.accent : AppColors.text2,
          ),
        ),
      ),
    );
  }
}

// ─── Toggle Switch ────────────────────────────────────────────────────────────

class AppToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggle({super.key, required this.value, required this.onChanged});

  @override
  State<AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<AppToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.value ? 1.0 : 0.0,
    );
    _slide = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(AppToggle old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _slide,
        builder: (_, __) {
          final t = _slide.value;
          return Container(
            width: 44, height: 24,
            decoration: BoxDecoration(
              color: Color.lerp(AppColors.surface3, AppColors.accent, t),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Align(
                alignment: Alignment.lerp(
                  Alignment.centerLeft, Alignment.centerRight, t)!,
                child: Container(
                  width: 18, height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Section Label ─────────────────────────────────────────────────────────────

class SectionLabel extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const SectionLabel(this.text, {super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.text3,
          letterSpacing: 0.8,
          fontFamily: 'SpaceGrotesk',
        ),
      ),
    );
  }
}

// ─── Settings Row ─────────────────────────────────────────────────────────────

class SettingsRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget trailing;
  final bool showDivider;

  const SettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: const TextStyle(fontSize: 14, color: AppColors.text)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!,
                        style: const TextStyle(fontSize: 12, color: AppColors.text3)),
                    ],
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 0),
      ],
    );
  }
}

// ─── Download Status Badge ────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const StatusBadge({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
  });

  factory StatusBadge.done() => const StatusBadge(
    label: '✓  Done',
    bg: Color(0x2622C55E),
    fg: AppColors.green,
  );
  factory StatusBadge.audio() => const StatusBadge(
    label: '♪  Audio',
    bg: Color(0x26F59E0B),
    fg: AppColors.amber,
  );
  factory StatusBadge.error() => const StatusBadge(
    label: '✕  Error',
    bg: Color(0x26EF4444),
    fg: AppColors.red,
  );
  factory StatusBadge.converting() => const StatusBadge(
    label: '⟳  Converting',
    bg: Color(0x267C6FF7),
    fg: AppColors.accent,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          fontFamily: 'SpaceGrotesk',
        ),
      ),
    );
  }
}
