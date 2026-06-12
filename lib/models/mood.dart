import 'package:flutter/material.dart';

/// The ten core moods a user can select.
enum Mood {
  calm,
  motivated,
  hopeful,
  grieving,
  angry,
  anxious,
  lonely,
  reflective,
  joyful,
  disciplined,
}

/// Display configuration for each mood.
class MoodConfig {
  final Mood mood;
  final String label;
  final IconData icon;
  final Color color;

  const MoodConfig({
    required this.mood,
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// All mood configurations keyed by [Mood].
const Map<Mood, MoodConfig> moodConfigs = {
  Mood.calm: MoodConfig(
    mood: Mood.calm,
    label: 'Calm',
    icon: Icons.spa_outlined,
    color: Color(0xFF81B9A4),
  ),
  Mood.motivated: MoodConfig(
    mood: Mood.motivated,
    label: 'Motivated',
    icon: Icons.bolt_outlined,
    color: Color(0xFFF4A261),
  ),
  Mood.hopeful: MoodConfig(
    mood: Mood.hopeful,
    label: 'Hopeful',
    icon: Icons.wb_sunny_outlined,
    color: Color(0xFFE9C46A),
  ),
  Mood.grieving: MoodConfig(
    mood: Mood.grieving,
    label: 'Grieving',
    icon: Icons.favorite_border,
    color: Color(0xFF9B8EA6),
  ),
  Mood.angry: MoodConfig(
    mood: Mood.angry,
    label: 'Angry',
    icon: Icons.whatshot_outlined,
    color: Color(0xFFE76F51),
  ),
  Mood.anxious: MoodConfig(
    mood: Mood.anxious,
    label: 'Anxious',
    icon: Icons.air_outlined,
    color: Color(0xFF7BAFD4),
  ),
  Mood.lonely: MoodConfig(
    mood: Mood.lonely,
    label: 'Lonely',
    icon: Icons.nights_stay_outlined,
    color: Color(0xFF6D8B9F),
  ),
  Mood.reflective: MoodConfig(
    mood: Mood.reflective,
    label: 'Reflective',
    icon: Icons.self_improvement_outlined,
    color: Color(0xFFA8C5A0),
  ),
  Mood.joyful: MoodConfig(
    mood: Mood.joyful,
    label: 'Joyful',
    icon: Icons.star_border,
    color: Color(0xFFFFB347),
  ),
  Mood.disciplined: MoodConfig(
    mood: Mood.disciplined,
    label: 'Disciplined',
    icon: Icons.fitness_center_outlined,
    color: Color(0xFF7B8B9A),
  ),
};

extension MoodExtension on Mood {
  String get name => toString().split('.').last;

  MoodConfig get config => moodConfigs[this]!;
}
