import 'package:flutter/material.dart';

class PriorityHelper {
  static Color getColorFromPriority(int priority) {
    switch (priority) {
      case 1:
        return Colors.blue.withOpacity(0.3);
      case 2:
        return Colors.orange.withOpacity(0.3);
      case 3:
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.grey.withOpacity(0.3);
    }
  }

  static String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown';
    }
  }

  static Color getPriorityTextColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 