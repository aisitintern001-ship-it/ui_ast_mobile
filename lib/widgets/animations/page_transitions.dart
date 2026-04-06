import 'package:flutter/material.dart';

/// Beautiful page route transitions for navigation
class AppPageTransitions {
  /// Slide up transition - great for modals and detail screens
  static Route<T> slideUp<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  /// Slide left transition - standard forward navigation
  static Route<T> slideLeft<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade scale transition - great for floating action dialogs
  static Route<T> fadeScale<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis transition - Material Design 3 style
  static Route<T> sharedAxisX<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 350),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Vertical shared axis transition
  static Route<T> sharedAxisY<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 350),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade through transition - for switching between unrelated destinations
  static Route<T> fadeThrough<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Hero dialog transition - for hero-like modal presentations
  static Route<T> heroDialog<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 350),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// No animation - instant transition
  static Route<T> none<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  /// iOS style slide transition with parallax effect
  static Route<T> cupertino<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 400),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final primaryAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        // Incoming page slides from right with slight shadow
        return Stack(
          children: [
            // Shadow overlay on the previous page
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 0.25).animate(primaryAnimation),
              child: Container(color: Colors.black),
            ),
            // New page sliding in
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(primaryAnimation),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(-5, 0),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Zoom fade transition
  static Route<T> zoomFade<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration ?? const Duration(milliseconds: 400),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.1, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}

/// Extension to easily navigate with custom transitions
extension NavigatorExtensions on NavigatorState {
  Future<T?> pushSlideUp<T>(Widget page) {
    return push(AppPageTransitions.slideUp<T>(page));
  }

  Future<T?> pushSlideLeft<T>(Widget page) {
    return push(AppPageTransitions.slideLeft<T>(page));
  }

  Future<T?> pushFadeScale<T>(Widget page) {
    return push(AppPageTransitions.fadeScale<T>(page));
  }

  Future<T?> pushFadeThrough<T>(Widget page) {
    return push(AppPageTransitions.fadeThrough<T>(page));
  }

  Future<T?> pushSharedAxis<T>(Widget page) {
    return push(AppPageTransitions.sharedAxisX<T>(page));
  }

  Future<T?> pushCupertino<T>(Widget page) {
    return push(AppPageTransitions.cupertino<T>(page));
  }

  Future<T?> pushZoomFade<T>(Widget page) {
    return push(AppPageTransitions.zoomFade<T>(page));
  }
}

/// Extension for BuildContext for easier navigation
extension ContextNavigatorExtensions on BuildContext {
  Future<T?> pushSlideUp<T>(Widget page) {
    return Navigator.of(this).pushSlideUp<T>(page);
  }

  Future<T?> pushSlideLeft<T>(Widget page) {
    return Navigator.of(this).pushSlideLeft<T>(page);
  }

  Future<T?> pushFadeScale<T>(Widget page) {
    return Navigator.of(this).pushFadeScale<T>(page);
  }

  Future<T?> pushFadeThrough<T>(Widget page) {
    return Navigator.of(this).pushFadeThrough<T>(page);
  }

  Future<T?> pushCupertino<T>(Widget page) {
    return Navigator.of(this).pushCupertino<T>(page);
  }
}
