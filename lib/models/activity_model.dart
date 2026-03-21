// lib/models/activity_model.dart

class ActivityModel {
  final String title;
  final String description;
  final String intensity;     // Low / Medium / High
  final String duration;      // e.g. "30 mins"
  final String videoAsset;    // asset path or URL
  final String emoji;

  ActivityModel({
    required this.title,
    required this.description,
    required this.intensity,
    required this.duration,
    required this.videoAsset,
    required this.emoji,
  });

  // ── Health Logic Engine ─────────────────────────────────────────────────────
  // Matrix: weatherCondition × ageGroup × weightCategory → suggested activities
  static List<ActivityModel> getSuggestions({
    required String weatherCondition,
    required String ageGroup,       // 'young' | 'senior'
    required String weightCategory, // 'Normal' | 'Overweight' | 'Obese' | 'Underweight'
  }) {
    final w = weatherCondition.toLowerCase();
    final isOverweight =
        weightCategory == 'Overweight' || weightCategory == 'Obese';

    // Extreme heat
    if (w == 'extreme_heat') {
      return [
        ActivityModel(
          title: 'Swimming',
          description: 'Cool off while building full-body strength. '
              'Great for all fitness levels.',
          intensity: 'Medium',
          duration: '40 mins',
          videoAsset: 'assets/videos/swimming.mp4',
          emoji: '🏊',
        ),
        ActivityModel(
          title: 'Hydrated Light Stretching',
          description: 'Gentle stretching indoors with regular hydration '
              'breaks. Improves flexibility safely in heat.',
          intensity: 'Low',
          duration: '20 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🧘',
        ),
      ];
    }

    // Rain or Snow
    if (w == 'rain' || w == 'snow') {
      return [
        ActivityModel(
          title: 'Indoor Yoga',
          description: 'Relax and strengthen your core from the comfort '
              'of your home. Great for any weather.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/yoga.mp4',
          emoji: '🧘',
        ),
        ActivityModel(
          title: 'Bodyweight Circuit',
          description: 'Push-ups, squats, lunges — no equipment needed. '
              'Burns calories effectively indoors.',
          intensity: 'High',
          duration: '25 mins',
          videoAsset: 'assets/videos/circuit.mp4',
          emoji: '💪',
        ),
      ];
    }

    // Clear / Sunny
    if (w == 'clear' || w == 'cloud') {
      if (ageGroup == 'senior') {
        return [
          ActivityModel(
            title: 'Morning Walk',
            description: 'A brisk walk in the fresh air. Excellent '
                'cardiovascular exercise for all ages.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/walking.mp4',
            emoji: '🚶',
          ),
          ActivityModel(
            title: 'Tai Chi in the Park',
            description: 'Ancient practice combining slow movements and '
                'deep breathing. Improves balance and flexibility.',
            intensity: 'Low',
            duration: '45 mins',
            videoAsset: 'assets/videos/taichi.mp4',
            emoji: '🌿',
          ),
        ];
      } else if (isOverweight) {
        return [
          ActivityModel(
            title: 'Swimming',
            description: 'Low impact, high reward. Supports joints while '
                'burning significant calories.',
            intensity: 'Medium',
            duration: '40 mins',
            videoAsset: 'assets/videos/swimming.mp4',
            emoji: '🏊',
          ),
          ActivityModel(
            title: 'Outdoor Cycling',
            description: 'Gentle on joints and effective for weight loss. '
                'Enjoy the sunshine while you ride.',
            intensity: 'Medium',
            duration: '45 mins',
            videoAsset: 'assets/videos/cycling.mp4',
            emoji: '🚴',
          ),
        ];
      } else {
        return [
          ActivityModel(
            title: 'Outdoor Running',
            description: 'High-intensity cardio that builds endurance '
                'and burns fat quickly. Best on clear days.',
            intensity: 'High',
            duration: '30 mins',
            videoAsset: 'assets/videos/running.mp4',
            emoji: '🏃',
          ),
          ActivityModel(
            title: 'HIIT Training',
            description: 'High-Intensity Interval Training. Maximum '
                'calorie burn in minimum time.',
            intensity: 'High',
            duration: '20 mins',
            videoAsset: 'assets/videos/hiit.mp4',
            emoji: '⚡',
          ),
        ];
      }
    }

    // Default fallback
    return [
      ActivityModel(
        title: 'Indoor Yoga',
        description: 'A safe and effective activity for any condition.',
        intensity: 'Low',
        duration: '30 mins',
        videoAsset: 'assets/videos/yoga.mp4',
        emoji: '🧘',
      ),
    ];
  }
}
