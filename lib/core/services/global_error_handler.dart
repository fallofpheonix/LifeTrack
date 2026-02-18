import 'package:flutter/material.dart';
import 'package:lifetrack/core/services/health_log.dart';

class GlobalErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    HealthLog.e(
      'GlobalErrorHandler', 
      'HandleFlutterError', 
      'Flutter Framework Error: ${details.summary}',
      error: details.exception,
      stackTrace: details.stack,
    );
  }

  static void handleAsyncError(Object error, StackTrace stack) {
    HealthLog.e(
      'GlobalErrorHandler', 
      'HandleAsyncError', 
      'Uncaught Async Error', 
      error: error, 
      stackTrace: stack,
    );
  }
}

class AppErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const AppErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ?? 
             _defaultErrorScreen(context, _error!);
    }
    
    // Create a new ErrorWidget builder for children
    // Create a new ErrorWidget builder for children
    ErrorWidget.builder = (FlutterErrorDetails details) {
        HealthLog.e('AppErrorBoundary', 'UI Build Error', 'Flutter Framework Error', error: details.exception, stackTrace: details.stack);
        return _defaultErrorScreen(context, details.exception);
    };
    
    return widget.child;
    

  }
  
  // This widget is actually more of a placeholder for where we *would* wrap functionality 
  // if Flutter had a React-style ErrorBoundary. 
  // For now, let's implement the localized UI part.
  
  Widget _defaultErrorScreen(BuildContext context, Object error) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'We encountered an unexpected problem.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                   // Verify if we can "reset". In a global crash, usually need full restart.
                   // But maybe just popping?
                   if (Navigator.canPop(context)) {
                     Navigator.pop(context);
                   }
                }, 
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
