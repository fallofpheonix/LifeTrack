import 'package:flutter/material.dart';
import 'health_log.dart';

class FeedbackService {
  static void showUnifiedFeedback(BuildContext context, {
    required String message,
    bool isError = false,
    VoidCallback? onUndo,
  }) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red.shade700 : Colors.teal.shade700,
      behavior: SnackBarBehavior.floating,
      action: onUndo != null 
          ? SnackBarAction(
              label: 'UNDO', 
              textColor: Colors.amber, 
              onPressed: onUndo
            ) 
          : null,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Haptics for reinforcement
    // HapticFeedback.lightImpact(); // Requires import
  }

  static Future<void> submitUserReport(String text) async {
    HealthLog.audit('FeedbackService', 'Submit', 'User Feedback Submitted', userId: 'current_user', details: {'text': text});
    // TODO: Send to backend
    await Future.delayed(const Duration(seconds: 1));
  }
}
