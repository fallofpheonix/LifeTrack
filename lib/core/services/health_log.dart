import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error, audit }

class HealthLog {
  static void d(String feature, String action, String message) {
    _log(LogLevel.debug, feature, action, message);
  }

  static void i(String feature, String action, String message, {String? entityId}) {
    _log(LogLevel.info, feature, action, message, entityId: entityId);
  }

  static void w(String feature, String action, String message, {Object? error, String? entityId}) {
    _log(LogLevel.warning, feature, action, message, error: error, entityId: entityId);
  }

  static void e(String feature, String action, String message, {Object? error, StackTrace? stackTrace, String? entityId}) {
    _log(LogLevel.error, feature, action, message, error: error, stackTrace: stackTrace, entityId: entityId);
  }

  static void audit(String feature, String action, String message, {required String userId, Map<String, dynamic>? details}) {
    final String detailsStr = details != null ? details.toString() : '';
    // Audit logs are special, they retain user ID explicitly in the message for compliance
    _log(LogLevel.audit, feature, action, 'USER:$userId $message $detailsStr');
  }

  static void _log(LogLevel level, String feature, String action, String message, {Object? error, StackTrace? stackTrace, String? entityId}) {
    if (!kDebugMode && level == LogLevel.debug) return;

    final String timestamp = DateTime.now().toIso8601String();
    final String emoji = _getEmoji(level);
    final String entityStr = entityId != null ? '[$entityId]' : '';

    // Standardized log format: EMOJI TIMESTAMP [FEATURE] [ACTION] [ENTITY] MESSAGE
    final String formattedMessage = '$emoji $timestamp [$feature] [$action] $entityStr $message';

    if (level == LogLevel.error) {
       developer.log(
         formattedMessage, 
         name: feature, 
         error: error, 
         stackTrace: stackTrace,
         level: 1000 // Severe
       );
    } else {
       debugPrint(formattedMessage);
       if (error != null) debugPrint(error.toString());
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug: return '🐛';
      case LogLevel.info: return 'ℹ️';
      case LogLevel.warning: return '⚠️';
      case LogLevel.error: return '🚨';
      case LogLevel.audit: return '🔒';
    }
  }
}
