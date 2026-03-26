// lib/views/widgets/activity_card.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/activity_model.dart';
import '../../utils/app_theme.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.cyan : AppColors.cyanDark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedColor =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final cardBg = isDark ? AppColors.slateSurfacePlus : AppColors.white;
    final cardBorder =
        isDark ? AppColors.borderCyanDark : AppColors.borderCyanLight;
    final iconBg = isDark
        ? AppColors.borderCyanDark.withOpacity(0.2)
        : AppColors.borderCyanLight.withOpacity(0.4);

    return GestureDetector(
      onTap: () => _openVideo(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder, width: 0.8),
        ),
        child: Row(children: [
          // ── Icon box ────────────────────────────────────────────────────
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardBorder, width: 0.8),
            ),
            child: Center(
              child: Text(activity.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),

          // ── Info ─────────────────────────────────────────────────────────
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(activity.title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(activity.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: mutedColor, fontSize: 10, height: 1.4)),
              const SizedBox(height: 7),
              Row(children: [
                _Chip(activity.intensity,
                    _intensityColor(activity.intensity, isDark),
                    textColor: _intensityTextColor(activity.intensity, isDark)),
                const SizedBox(width: 6),
                _Chip(activity.duration,
                    isDark ? AppColors.slateSurfaceHighlight : AppColors.lightSurf,
                    textColor: mutedColor, border: cardBorder),
              ]),
            ]),
          ),

          const SizedBox(width: 10),

          // ── Play button ──────────────────────────────────────────────────
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.cyan : AppColors.cyanDark),
            child: Icon(Icons.play_arrow_rounded,
                color: isDark ? AppColors.slateBase : AppColors.white, size: 20),
          ),
        ]),
      ),
    );
  }

  Color _intensityColor(String intensity, bool isDark) {
    switch (intensity.toLowerCase()) {
      case 'high':
        return isDark
            ? const Color(0xFFFF5F5F).withOpacity(0.15)
            : const Color(0xFFFFEBEB);
      case 'medium':
        return isDark
            ? AppColors.warning.withOpacity(0.15)
            : const Color(0xFFFFF8E1);
      default:
        return isDark
            ? AppColors.success.withOpacity(0.15)
            : const Color(0xFFE8F5E9);
    }
  }

  Color _intensityTextColor(String intensity, bool isDark) {
    switch (intensity.toLowerCase()) {
      case 'high':
        return isDark ? const Color(0xFFFF5F5F) : AppColors.error;
      case 'medium':
        return isDark ? AppColors.warning : const Color(0xFFF57F17);
      default:
        return isDark ? AppColors.success : const Color(0xFF2E7D32);
    }
  }

  void _openVideo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VideoSheet(activity: activity),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final Color? border;

  const _Chip(this.label, this.bg, {required this.textColor, this.border});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(5),
          border:
              border != null ? Border.all(color: border!, width: 0.5) : null,
        ),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: textColor,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
      );
}

// ── Video sheet ───────────────────────────────────────────────────────────────
class _VideoSheet extends StatefulWidget {
  final ActivityModel activity;
  const _VideoSheet({required this.activity});
  @override
  State<_VideoSheet> createState() => _VideoSheetState();
}

class _VideoSheetState extends State<_VideoSheet> {
  VideoPlayerController? _vpc;
  ChewieController? _cc;
  bool _hasVideo = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _vpc = VideoPlayerController.asset(widget.activity.videoAsset);
      await _vpc!.initialize();
      _cc = ChewieController(
          videoPlayerController: _vpc!,
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9);
      setState(() => _hasVideo = true);
    } catch (_) {
      setState(() => _hasVideo = false);
    }
  }

  @override
  void dispose() {
    _cc?.dispose();
    _vpc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.slateSurface : AppColors.white;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedColor =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final goldColor = isDark ? AppColors.cyan : AppColors.cyanDark;
    final divider =
        isDark ? AppColors.borderCyanDark : AppColors.borderCyanLight;
    final chipBg = isDark ? AppColors.slateSurfacePlus : AppColors.lightSurf;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      expand: false,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: divider, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _hasVideo && _cc != null
                ? Chewie(controller: _cc!)
                : _Placeholder(
                    activity: widget.activity,
                    isDark: isDark,
                    textColor: mutedColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: ctrl,
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(widget.activity.emoji,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(widget.activity.title,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      _VideoChip(widget.activity.intensity,
                          bg: chipBg, textColor: mutedColor, border: divider),
                      const SizedBox(width: 8),
                      _VideoChip(widget.activity.duration,
                          bg: chipBg, textColor: mutedColor, border: divider),
                    ]),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: divider),
                    const SizedBox(height: 14),
                    Text(widget.activity.description,
                        style: TextStyle(
                            color: mutedColor, fontSize: 14, height: 1.6)),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final ActivityModel activity;
  final bool isDark;
  final Color textColor;
  const _Placeholder(
      {required this.activity, required this.isDark, required this.textColor});
  @override
  Widget build(BuildContext context) => Container(
        color: isDark ? AppColors.slateSurfacePlus : AppColors.lightSurf,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(activity.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('AI-Generated Exercise Video',
              style: TextStyle(color: textColor, fontSize: 13)),
          const SizedBox(height: 4),
          Text('Add video to assets/videos/',
              style:
                  TextStyle(color: textColor.withOpacity(0.5), fontSize: 10)),
        ]),
      );
}

class _VideoChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final Color border;
  const _VideoChip(this.label,
      {required this.bg, required this.textColor, required this.border});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: border, width: 0.8),
        ),
        child: Text(label.toUpperCase(),
            style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
      );
}
