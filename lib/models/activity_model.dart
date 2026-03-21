// lib/models/activity_model.dart

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
    required String ageGroup, // 'young' | 'senior'
    required String
        weightCategory, // 'Normal' | 'Overweight' | 'Obese' | 'Underweight'
  }) {
    final w = weatherCondition.toLowerCase();
    final isOverweight =
        weightCategory == 'Overweight' || weightCategory == 'Obese';
    final isUnderweight = weightCategory == 'Underweight';

    // ── Extreme Heat ─────────────────────────────────────────────────────────
    if (w == 'extreme_heat') {
      return [
        ActivityModel(
          title: 'Swimming',
          description: 'Cool off while building full-body strength. '
              'Best exercise during extreme heat — water keeps you cool.',
          intensity: 'Medium',
          duration: '40 mins',
          videoAsset: 'assets/videos/swimming.mp4',
          emoji: '🏊',
        ),
        ActivityModel(
          title: 'Hydrated Light Stretching',
          description: 'Gentle full-body stretching with regular water '
              'breaks. Improves flexibility without overheating.',
          intensity: 'Low',
          duration: '20 mins',
          videoAsset: 'assets/videos/stretching.mp4',
          emoji: '🧘',
        ),
        ActivityModel(
          title: 'Indoor Yoga',
          description: 'Stay cool indoors while strengthening your core '
              'and improving mental focus through mindful movement.',
          intensity: 'Low',
          duration: '30 mins',
          videoAsset: 'assets/videos/yoga.mp4',
          emoji: '🌸',
        ),
      ];
    }

    // ── Rain or Snow ──────────────────────────────────────────────────────────
    if (w == 'rain' || w == 'snow') {
      if (ageGroup == 'senior') {
        return [
          ActivityModel(
            title: 'Indoor Yoga',
            description: 'Gentle yoga indoors to maintain flexibility '
                'and balance. Perfect for rainy days at any age.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🧘',
          ),
          ActivityModel(
            title: 'Chair Exercises',
            description: 'Seated stretching and strength exercises. '
                'Safe, effective and easy on the joints.',
            intensity: 'Low',
            duration: '25 mins',
            videoAsset: 'assets/videos/stretching.mp4',
            emoji: '🪑',
          ),
          ActivityModel(
            title: 'Indoor Walking',
            description: 'Walk around your home or a mall. Maintains '
                'cardiovascular health without going outdoors.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/walking.mp4',
            emoji: '🚶',
          ),
        ];
      } else if (isOverweight) {
        return [
          ActivityModel(
            title: 'Indoor Yoga',
            description: 'Low-impact full body workout. Builds strength '
                'and flexibility without straining joints.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🧘',
          ),
          ActivityModel(
            title: 'Bodyweight Circuit',
            description: 'Modified push-ups, squats and lunges at your '
                'own pace. Burns calories with no equipment needed.',
            intensity: 'Medium',
            duration: '25 mins',
            videoAsset: 'assets/videos/circuit.mp4',
            emoji: '💪',
          ),
          ActivityModel(
            title: 'Indoor Cycling',
            description: 'Stationary bike or low-impact stepping indoors. '
                'Great cardio that is gentle on the knees.',
            intensity: 'Medium',
            duration: '35 mins',
            videoAsset: 'assets/videos/cycling.mp4',
            emoji: '🚴',
          ),
        ];
      } else {
        return [
          ActivityModel(
            title: 'Bodyweight Circuit',
            description: 'Push-ups, squats, lunges and burpees at home. '
                'Maximum calorie burn with zero equipment.',
            intensity: 'High',
            duration: '25 mins',
            videoAsset: 'assets/videos/circuit.mp4',
            emoji: '💪',
          ),
          ActivityModel(
            title: 'Indoor HIIT',
            description: 'High-Intensity Interval Training you can do '
                'in your living room. Burn fat fast on rainy days.',
            intensity: 'High',
            duration: '20 mins',
            videoAsset: 'assets/videos/hiit.mp4',
            emoji: '⚡',
          ),
          ActivityModel(
            title: 'Indoor Yoga',
            description: 'Balance your intense sessions with restorative '
                'yoga. Improves flexibility and reduces stress.',
            intensity: 'Low',
            duration: '30 mins',
            videoAsset: 'assets/videos/yoga.mp4',
            emoji: '🧘',
          ),
        ];
      }
    }

    // ── Clear / Sunny / Cloudy ────────────────────────────────────────────────
    if (w == 'clear' || w == 'cloud') {
      // Senior (50+) — any weight
      if (ageGroup == 'senior') {
        return [
          ActivityModel(
            title: 'Morning Walk',
            description: 'A brisk walk in the fresh air. Excellent '
                'cardiovascular exercise that is gentle on joints.',
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
          ActivityModel(
            title: 'Light Stretching Outdoors',
            description: 'Outdoor stretching under fresh air and sunlight. '
                'Boosts mood and improves joint mobility.',
            intensity: 'Low',
            duration: '20 mins',
            videoAsset: 'assets/videos/stretching.mp4',
            emoji: '☀️',
          ),
        ];
      }

      // Young + Overweight
      if (isOverweight) {
        return [
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
        ];
      }

      // Young + Underweight
      if (isUnderweight) {
        return [
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
        ];
      }

      // Young + Normal/Athletic
      return [
        ActivityModel(
          title: 'Outdoor Running',
          description: 'High-intensity cardio that builds endurance '
              'and burns fat. Perfect on clear and sunny days.',
          intensity: 'High',
          duration: '30 mins',
          videoAsset: 'assets/videos/running.mp4',
          emoji: '🏃',
        ),
        ActivityModel(
          title: 'HIIT Training',
          description: 'High-Intensity Interval Training for maximum '
              'calorie burn in minimum time. Outdoors or indoors.',
          intensity: 'High',
          duration: '20 mins',
          videoAsset: 'assets/videos/hiit.mp4',
          emoji: '⚡',
        ),
        ActivityModel(
          title: 'Outdoor Cycling',
          description: 'Speed cycling builds leg strength and '
              'cardiovascular endurance. Enjoy the sunshine.',
          intensity: 'Medium',
          duration: '45 mins',
          videoAsset: 'assets/videos/cycling.mp4',
          emoji: '🚴',
        ),
      ];
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
