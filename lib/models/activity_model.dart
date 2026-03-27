// lib/models/activity_model.dart

import 'dart:math';

class ActivityModel {
  final String title;
  final String description;
  final String intensity; // Low / Medium / High
  final String duration;
  final String videoAsset;
  final String emoji;

  ActivityModel({
    required this.title,
    required this.description,
    required this.intensity,
    required this.duration,
    required this.videoAsset,
    required this.emoji,
  });

  // ── Health Logic Engine ───────────────────────────────────────────────────
  // Matrix: weatherCondition × ageGroup × weightCategory → 3 suggestions
  static List<ActivityModel> getSuggestions({
    required String weatherCondition,
    required String ageGroup, // 'young' (<50) | 'senior' (>=50)
    required String
        weightCategory, // 'Normal' | 'Overweight' | 'Obese' | 'Underweight'
    int seed = 0,
  }) {
    final w = weatherCondition.toLowerCase();
    final isOverweight =
        weightCategory == 'Overweight' || weightCategory == 'Obese';
    final isUnderweight = weightCategory == 'Underweight';

    List<ActivityModel> pick3(List<ActivityModel> options) {
      // Deterministic shuffle so small profile changes can change results,
      // while keeping outputs stable for the same inputs.
      final r = Random(
        seed ^
            w.hashCode ^
            ageGroup.hashCode ^
            weightCategory.hashCode,
      );
      final list = List<ActivityModel>.from(options);
      for (var i = list.length - 1; i > 0; i--) {
        final j = r.nextInt(i + 1);
        final tmp = list[i];
        list[i] = list[j];
        list[j] = tmp;
      }
      return list.take(3).toList();
    }

    // ── Extreme Heat ─────────────────────────────────────────────────────────
    if (w == 'extreme_heat') {
      // Per matrix: Extreme heat + Overweight → Swimming / Hydrated Stretching.
      // We expand options but keep them heat-safe.
      final options = <ActivityModel>[
        ActivityModel(
          title: 'Swimming',
          description: 'Cool off while building full-body strength. '
              'Best during extreme heat—water keeps you cool.',
          intensity: 'Medium',
          duration: '40 mins',
          videoAsset: 'assets/videos/swimming.mp4',
          emoji: '🏊',
        ),
        ActivityModel(
          title: 'Hydrated Light Stretching',
          description: 'Gentle full-body stretching with regular water breaks. '
              'Improves flexibility without overheating.',
          intensity: 'Low',
          duration: '20 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🧘',
        ),
        ActivityModel(
          title: 'Indoor Yoga',
          description: 'Stay cool indoors while strengthening your core '
              'through mindful movement.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/yoga.mp4',
          emoji: '🌿',
        ),
        ActivityModel(
          title: 'Breathing + Mobility',
          description: 'Short breathing and joint-mobility session indoors. '
              'Low sweat, high recovery.',
          intensity: 'Low',
          duration: '15 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🫁',
        ),
        ActivityModel(
          title: 'Light Indoor Walk',
          description: 'Easy pacing indoors with fans/AC. Keep intensity low '
              'and hydrate often.',
          intensity: 'Low',
          duration: '25 mins',
          videoAsset: 'assets/videos/walking.mp4',
          emoji: '🚶',
        ),
      ];

      // If not overweight, still give heat-safe options.
      if (!isOverweight) {
        return pick3(options);
      }
      return pick3(options);
    }

    // ── Rain or Snow ──────────────────────────────────────────────────────────
    if (w == 'rain' || w == 'snow') {
      // Per matrix: Rain/Snow → Indoor Yoga / Bodyweight Circuit (any age/weight).
      // Expand with more indoor-safe options.
      final options = <ActivityModel>[
        ActivityModel(
          title: 'Indoor Yoga',
          description: 'Gentle yoga indoors to maintain flexibility and balance.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/yoga.mp4',
          emoji: '🧘',
        ),
        ActivityModel(
          title: 'Bodyweight Circuit',
          description: 'Push-ups, squats, lunges—adjust pace to your level. '
              'No equipment needed.',
          intensity: isOverweight ? 'Medium' : 'High',
          duration: '25 mins',
          videoAsset: 'assets/videos/circuit.mp4',
          emoji: '💪',
        ),
        ActivityModel(
          title: 'Indoor Walking',
          description: 'Walk around your home to keep your heart healthy.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/walking.mp4',
          emoji: '🚶',
        ),
        ActivityModel(
          title: 'Low-Impact Dance',
          description: 'Fun indoor cardio with low-impact steps—great for mood.',
          intensity: 'Medium',
          duration: '20 mins',
          videoAsset: 'assets/videos/hiit.mp4',
          emoji: '💃',
        ),
        ActivityModel(
          title: 'Chair Exercises',
          description: 'Seated strength and stretching—joint-friendly option.',
          intensity: 'Low',
          duration: '20 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🪑',
        ),
        ActivityModel(
          title: 'Core + Mobility',
          description: 'Short core activation plus mobility work to stay pain-free.',
          intensity: 'Low',
          duration: '18 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🧩',
        ),
      ];

      // Seniors: bias to joint-friendly options by repeating them in pool.
      if (ageGroup == 'senior') {
        options.addAll([
          options[0],
          options[3],
          options[4],
        ]);
      }
      return pick3(options);
    }

    // ── Clear / Sunny / Cloudy ────────────────────────────────────────────────
    if (w == 'clear' || w == 'cloud') {
      // Senior (50+) — any weight
      if (ageGroup == 'senior') {
        final options = <ActivityModel>[
          ActivityModel(
            title: 'Morning Walk',
            description: 'A steady walk in fresh air—excellent cardio that is gentle on joints.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/walking.mp4',
            emoji: '🚶',
          ),
          ActivityModel(
            title: 'Tai Chi in the Park',
            description: 'Slow movements + deep breathing to improve balance and flexibility.',
            intensity: 'Low',
            duration: '45 mins',
            videoAsset: 'assets/videos/taichi.mp4',
            emoji: '🌿',
          ),
          ActivityModel(
            title: 'Light Stretching Outdoors',
            description: 'Outdoor stretching to improve mobility and boost mood.',
            intensity: 'Low',
            duration: '20 mins',
            videoAsset: 'assets/videos/stretching.mp4',
            emoji: '☀️',
          ),
          ActivityModel(
            title: 'Gentle Cycling',
            description: 'Low-impact ride for joint-friendly cardio.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/cycling.mp4',
            emoji: '🚴',
          ),
          ActivityModel(
            title: 'Park Bench Strength',
            description: 'Simple strength work (sit-to-stand, wall push-ups) at your own pace.',
            intensity: 'Low',
            duration: '20 mins',
            videoAsset: 'assets/videos/circuit.mp4',
            emoji: '💪',
          ),
          ActivityModel(
            title: 'Outdoor Yoga',
            description: 'A calm session outdoors for flexibility and stress reduction.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🧘',
          ),
        ];
        return pick3(options);
      }

      // < 50 + Overweight
      if (isOverweight) {
        return pick3([
          ActivityModel(
            title: 'Outdoor Cycling',
            description: 'Gentle on joints and highly effective for '
                'weight loss. Enjoy fresh air while you ride.',
            intensity: 'Medium',
            duration: '45 mins',
            videoAsset: 'assets/videos/cycling.mp4',
            emoji: '🚴',
          ),
          ActivityModel(
            title: 'Swimming',
            description: 'Low impact, high reward. Supports your joints '
                'while burning significant calories.',
            intensity: 'Medium',
            duration: '40 mins',
            videoAsset: 'assets/videos/swimming.mp4',
            emoji: '🏊',
          ),
          ActivityModel(
            title: 'Brisk Walking',
            description: 'Power walking burns more calories than regular '
                'walking and is easy on your joints outdoors.',
            intensity: 'Low',
            duration: '40 mins',
            videoAsset: 'assets/videos/walking.mp4',
            emoji: '🚶',
          ),
          ActivityModel(
            title: 'Outdoor Yoga',
            description: 'Low-impact movement to build flexibility and reduce stress.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🧘',
          ),
        ]);
      }

      // < 50 + Underweight
      if (isUnderweight) {
        return pick3([
          ActivityModel(
            title: 'Outdoor Running',
            description: 'Build endurance and stimulate appetite. '
                'Running outdoors boosts energy and muscle growth.',
            intensity: 'Medium',
            duration: '25 mins',
            videoAsset: 'assets/videos/running.mp4',
            emoji: '🏃',
          ),
          ActivityModel(
            title: 'Bodyweight Strength',
            description: 'Push-ups, pull-ups and squats to build '
                'muscle mass. Essential for healthy weight gain.',
            intensity: 'Medium',
            duration: '30 mins',
            videoAsset: 'assets/videos/circuit.mp4',
            emoji: '💪',
          ),
          ActivityModel(
            title: 'Outdoor Yoga',
            description: 'Yoga in the fresh air improves flexibility, '
                'posture and appetite for healthy muscle building.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🌿',
          ),
          ActivityModel(
            title: 'Brisk Walking',
            description: 'Steady outdoor walk to build stamina without overtraining.',
            intensity: 'Low',
            duration: '35 mins',
            videoAsset: 'assets/videos/walking.mp4',
            emoji: '🚶',
          ),
        ]);
      }

      // < 50 + Normal/Athletic (per matrix: Outdoor Running / HIIT).
      final options = <ActivityModel>[
        ActivityModel(
          title: 'Outdoor Running',
          description: 'High-intensity cardio that builds endurance and burns fat.',
          intensity: 'High',
          duration: '30 mins',
          videoAsset: 'assets/videos/running.mp4',
          emoji: '🏃',
        ),
        ActivityModel(
          title: 'HIIT Training',
          description: 'Maximum calorie burn in minimum time. Great for clear days.',
          intensity: 'High',
          duration: '20 mins',
          videoAsset: 'assets/videos/hiit.mp4',
          emoji: '⚡',
        ),
        ActivityModel(
          title: 'Outdoor Cycling',
          description: 'Build leg strength and cardiovascular endurance outdoors.',
          intensity: 'Medium',
          duration: '45 mins',
          videoAsset: 'assets/videos/cycling.mp4',
          emoji: '🚴',
        ),
        ActivityModel(
          title: 'Brisk Walking',
          description: 'A sustainable outdoor cardio session that still burns calories.',
          intensity: 'Medium',
          duration: '35 mins',
          videoAsset: 'assets/videos/walking.mp4',
          emoji: '🚶',
        ),
        ActivityModel(
          title: 'Bodyweight Strength',
          description: 'Push-ups, squats, lunges—build strength with no equipment.',
          intensity: 'Medium',
          duration: '25 mins',
          videoAsset: 'assets/videos/circuit.mp4',
          emoji: '💪',
        ),
        ActivityModel(
          title: 'Outdoor Yoga',
          description: 'Balance high-intensity training with mobility and recovery.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/yoga.mp4',
          emoji: '🧘',
        ),
      ];
      return pick3(options);
    }

    // ── Default fallback ──────────────────────────────────────────────────────
    return [
      ActivityModel(
        title: 'Indoor Yoga',
        description: 'A safe and effective full-body activity '
            'suitable for any weather condition.',
        intensity: 'Low',
        duration: '30 mins',
        videoAsset: 'assets/videos/yoga.mp4',
        emoji: '🧘',
      ),
      ActivityModel(
        title: 'Light Stretching',
        description: 'Full-body stretching to improve flexibility '
            'and reduce muscle tension anytime.',
        intensity: 'Low',
        duration: '20 mins',
        videoAsset: 'assets/videos/stretching.mp4',
        emoji: '🌸',
      ),
      ActivityModel(
        title: 'Bodyweight Circuit',
        description: 'Basic push-ups, squats and lunges. '
            'No equipment needed, works anywhere.',
        intensity: 'Medium',
        duration: '25 mins',
        videoAsset: 'assets/videos/circuit.mp4',
        emoji: '💪',
      ),
    ];
  }
}
