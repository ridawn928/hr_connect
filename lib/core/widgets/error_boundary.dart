import 'package:flutter/material.dart';

/// A widget that catches errors in its child widget tree.
///
/// This widget provides a fallback UI when an error occurs within its
/// child hierarchy, preventing the entire application from crashing.
class ErrorBoundary extends StatefulWidget {
  /// The child widget that might throw errors.
  final Widget child;

  /// Creates a new [ErrorBoundary].
  const ErrorBoundary({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Error? _error;

  @override
  void initState() {
    super.initState();
    // Configure the Flutter error widget builder to show a custom error screen
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // Save the error for displaying
      _error = details.exception is Error 
          ? details.exception as Error 
          : Error();
      
      // Return a custom error display
      return Material(
        color: Colors.red[50],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[700],
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'An unexpected error occurred',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    details.exception.toString(),
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Attempt to recover by rebuilding the widget
                    setState(() {
                      _error = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 