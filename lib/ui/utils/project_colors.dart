import 'package:flutter/material.dart';

class ProjectColors {
  static const Map<String, ProjectColor> colors = {
    'berry_red':
        ProjectColor(id: 30, name: 'berry_red', color: Color(0xFFB8256F)),
    'red': ProjectColor(id: 31, name: 'red', color: Color(0xFFDB4035)),
    'orange': ProjectColor(id: 32, name: 'orange', color: Color(0xFFFF9933)),
    'yellow': ProjectColor(id: 33, name: 'yellow', color: Color(0xFFFAD000)),
    'olive_green':
        ProjectColor(id: 34, name: 'olive_green', color: Color(0xFFAFB83B)),
    'lime_green':
        ProjectColor(id: 35, name: 'lime_green', color: Color(0xFF7ECC49)),
    'green': ProjectColor(id: 36, name: 'green', color: Color(0xFF299438)),
    'mint_green':
        ProjectColor(id: 37, name: 'mint_green', color: Color(0xFF6ACCBC)),
    'teal': ProjectColor(id: 38, name: 'Teal', color: Color(0xFF158FAD)),
    'sky_blue':
        ProjectColor(id: 39, name: 'sky_blue', color: Color(0xFF14AAF5)),
    'light_blue':
        ProjectColor(id: 40, name: 'light_blue', color: Color(0xFF96C3EB)),
    'blue': ProjectColor(id: 41, name: 'blue', color: Color(0xFF4073FF)),
    'grape': ProjectColor(id: 42, name: 'grape', color: Color(0xFF884DFF)),
    'violet': ProjectColor(id: 43, name: 'violet', color: Color(0xFFAF38EB)),
    'lavender':
        ProjectColor(id: 44, name: 'lavender', color: Color(0xFFEB96EB)),
    'magenta': ProjectColor(id: 45, name: 'magenta', color: Color(0xFFE05194)),
    'salmon': ProjectColor(id: 46, name: 'salmon', color: Color(0xFFFF8D85)),
    'charcoal':
        ProjectColor(id: 47, name: 'charcoal', color: Color(0xFF808080)),
    'grey': ProjectColor(id: 48, name: 'grey', color: Color(0xFFB8B8B8)),
    'taupe': ProjectColor(id: 49, name: 'taupe', color: Color(0xFFCCAC93)),
  };

  static ProjectColor getColorById(int id) {
    return colors.values.firstWhere((color) => color.id == id);
  }

  static ProjectColor getColorByKey(String key) {
    return colors[key] ?? colors['grey']!;
  }

  static ProjectColor getColorByName(String name) {
    return colors.values.firstWhere(
      (color) => color.name == name,
      orElse: () => colors.values.first,
    );
  }
}

class ProjectColor {
  final int id;
  final String name;
  final Color color;

  const ProjectColor({
    required this.id,
    required this.name,
    required this.color,
  });
}
