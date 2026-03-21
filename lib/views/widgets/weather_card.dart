// lib/views/widgets/weather_card.dart

import 'package:flutter/material.dart';
import '../../models/weather_model.dart';
import '../../utils/app_theme.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldDark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedColor =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final cardBg = isDark ? AppColors.black3 : AppColors.white;
    final cardBorder =
        isDark ? AppColors.borderGold60 : AppColors.borderGoldLight;
    final iconBg = isDark
        ? AppColors.borderGoldDark.withOpacity(0.2)
        : AppColors.borderGoldLight.withOpacity(0.5);
    final divider =
        isDark ? AppColors.borderGoldDark : AppColors.borderGoldLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 0.8),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isDark
                      ? AppColors.borderGoldDark
                      : AppColors.borderGoldLight,
                  width: 0.8),
            ),
            child: Image.network(
              weather.iconUrl,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.cloud, color: goldColor, size: 28),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(weather.cityName,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(weather.description.toUpperCase(),
                  style: TextStyle(
                      color: goldColor,
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
          Text('${weather.temperature.toStringAsFixed(1)}°',
              style: TextStyle(
                  color: textColor, fontSize: 36, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 14),
        Divider(height: 1, color: divider),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _WeatherStat(
              icon: Icons.water_drop_outlined,
              label: 'HUMIDITY',
              value: '${weather.humidity.toStringAsFixed(0)}%',
              goldColor: goldColor,
              textColor: textColor,
              mutedColor: mutedColor),
          _WeatherStat(
              icon: Icons.thermostat_outlined,
              label: 'CONDITION',
              value: weather.condition,
              goldColor: goldColor,
              textColor: textColor,
              mutedColor: mutedColor),
          _WeatherStat(
              icon: Icons.fitness_center_outlined,
              label: 'ACTIVITY',
              value: _activityLevel(weather.normalizedCondition),
              goldColor: goldColor,
              textColor: textColor,
              mutedColor: mutedColor),
        ]),
      ]),
    );
  }

  String _activityLevel(String condition) {
    switch (condition) {
      case 'clear':
        return 'Outdoor';
      case 'rain':
      case 'snow':
        return 'Indoor';
      case 'extreme_heat':
        return 'Light';
      default:
        return 'Moderate';
    }
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color goldColor;
  final Color textColor;
  final Color mutedColor;

  const _WeatherStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.goldColor,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) => Column(children: [
        Icon(icon, color: goldColor, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: textColor, fontSize: 12, fontWeight: FontWeight.w700)),
        Text(label,
            style:
                TextStyle(color: mutedColor, fontSize: 8, letterSpacing: 0.8)),
      ]);
}
