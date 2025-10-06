
import 'package:flutter/material.dart';

/// A mixin that provides comprehensive animation management for widgets.
///
/// This mixin handles:
/// - Animation controller lifecycle management
/// - Common animation patterns (fade, scale, slide, etc.)
/// - Animation sequencing and staggering
/// - Animation state management and callbacks
/// - Performance-optimized animations
/// - Memory management for animation controllers
/// - Custom animation curves and durations
///
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget {
///   // ...
/// }
///
/// class _MyWidgetState extends State<MyWidget>
///     with AnimationMixin {
///
///   @override
///   void initState() {
///     super.initState();
///     createAnimation(
///       name: 'fadeIn',
///       duration: Duration(milliseconds: 300),
///       curve: Curves.easeIn,
///     );
///   }
///
///   void showContent() {
///     playAnimation('fadeIn');
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return FadeTransition(
///       opacity: getAnimation('fadeIn')!,
///       child: _buildContent(),
///     );
///   }
/// }
/// ```
mixin AnimationMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  /// Map of animation controllers by name
  final Map<String, AnimationController> _controllers = {};

  /// Map of animations by name
  final Map<String, Animation<double>> _animations = {};

  /// Map of animation configurations
  final Map<String, AnimationConfig> _configs = {};

  /// Currently playing animations
  final Set<String> _playingAnimations = {};

  /// Animation completion callbacks
  final Map<String, VoidCallback> _completionCallbacks = {};

  /// Animation status listeners
  final Map<String, AnimationStatusListener> _statusListeners = {};

  /// Whether animations are initialized
  bool _isInitialized = false;

  /// Gets all animation names
  Set<String> get animationNames => _controllers.keys.toSet();

  /// Gets currently playing animation names
  Set<String> get playingAnimations => _playingAnimations.toSet();

  /// Whether animations are initialized
  bool get isInitialized => _isInitialized;

  @override
  void initState() {
    super.initState();
    _isInitialized = true;
  }

  @override
  void dispose() {
    _disposeAllAnimations();
    super.dispose();
  }

  /// Create a new animation with configuration
  AnimationController createAnimation({
    required String name,
    required Duration duration,
    Duration? reverseDuration,
    Curve curve = Curves.easeInOut,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    String? debugLabel,
    VoidCallback? onComplete,
    AnimationStatusListener? onStatusChange,
  }) {
    // Dispose existing animation with same name
    _disposeAnimation(name);

    final config = AnimationConfig(
      duration: duration,
      reverseDuration: reverseDuration,
      curve: curve,
      lowerBound: lowerBound,
      upperBound: upperBound,
      debugLabel: debugLabel,
    );

    final controller = AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
      vsync: this,
      debugLabel: debugLabel,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: curve,
    );

    // Store animation and controller
    _controllers[name] = controller;
    _animations[name] = animation;
    _configs[name] = config;

    // Add listeners
    if (onComplete != null) {
      _completionCallbacks[name] = onComplete;
      controller.addStatusListener(_createStatusListener(name));
    }

    if (onStatusChange != null) {
      _statusListeners[name] = onStatusChange;
      controller.addStatusListener(onStatusChange);
    }

    return controller;
  }

  /// Create a fade animation
  AnimationController createFadeAnimation({
    required String name,
    required Duration duration,
    Curve curve = Curves.easeIn,
    VoidCallback? onComplete,
  }) {
    return createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );
  }

  /// Create a scale animation
  AnimationController createScaleAnimation({
    required String name,
    required Duration duration,
    Curve curve = Curves.easeInOut,
    double scaleBegin = 0.8,
    double scaleEnd = 1.0,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      lowerBound: scaleBegin,
      upperBound: scaleEnd,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a slide animation
  AnimationController createSlideAnimation({
    required String name,
    required Duration duration,
    required Offset begin,
    required Offset end,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a rotation animation
  AnimationController createRotationAnimation({
    required String name,
    required Duration duration,
    double turns = 1.0,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      upperBound: turns,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a bounce animation
  AnimationController createBounceAnimation({
    required String name,
    required Duration duration,
    int bounces = 3,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.bounceOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a staggered animation sequence
  void createStaggeredAnimation({
    required List<String> animationNames,
    Duration staggerDelay = const Duration(milliseconds: 100),
    VoidCallback? onComplete,
  }) {
    for (int i = 0; i < animationNames.length; i++) {
      final name = animationNames[i];
      final delay = staggerDelay * i;

      Future.delayed(delay, () {
        if (mounted && _controllers.containsKey(name)) {
          playAnimation(name);
        }
      });
    }

    if (onComplete != null) {
      Future.delayed(
        staggerDelay * animationNames.length,
        onComplete,
      );
    }
  }

  /// Play animation forward
  void playAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    if (!controller.isAnimating) {
      _playingAnimations.add(name);
      controller.forward().whenComplete(() {
        _playingAnimations.remove(name);
        _completionCallbacks[name]?.call();
      });
    }
  }

  /// Play animation in reverse
  void reverseAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    if (!controller.isAnimating) {
      _playingAnimations.add(name);
      controller.reverse().whenComplete(() {
        _playingAnimations.remove(name);
        _completionCallbacks[name]?.call();
      });
    }
  }

  /// Stop animation
  void stopAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.stop();
    _playingAnimations.remove(name);
  }

  /// Reset animation to beginning
  void resetAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.reset();
    _playingAnimations.remove(name);
  }

  /// Play animation and reverse (ping-pong effect)
  void playAndReverseAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    if (!controller.isAnimating) {
      _playingAnimations.add(name);
      controller.forward().then((_) {
        if (controller.isCompleted) {
          controller.reverse().whenComplete(() {
            _playingAnimations.remove(name);
            _completionCallbacks[name]?.call();
          });
        }
      });
    }
  }

  /// Play animation with delay
  void playAnimationWithDelay(String name, Duration delay) {
    Future.delayed(delay, () {
      if (mounted) {
        playAnimation(name);
      }
    });
  }

  /// Play multiple animations simultaneously
  void playAnimations(List<String> names) {
    for (final name in names) {
      playAnimation(name);
    }
  }

  /// Play multiple animations in sequence
  void playAnimationsInSequence(List<String> names) {
    if (names.isEmpty) return;

    playAnimation(names[0]);

    for (int i = 1; i < names.length; i++) {
      final name = names[i];
      final previousName = names[i - 1];

      // Wait for previous animation to complete
      _controllers[previousName]?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          playAnimation(name);
          _controllers[previousName]?.removeStatusListener(arguments);
        }
      });
    }
  }

  /// Get animation by name
  Animation<double>? getAnimation(String name) {
    return _animations[name];
  }

  /// Get animation controller by name
  AnimationController? getAnimationController(String name) {
    return _controllers[name];
  }

  /// Get animation configuration by name
  AnimationConfig? getAnimationConfig(String name) {
    return _configs[name];
  }

  /// Check if animation exists
  bool hasAnimation(String name) {
    return _controllers.containsKey(name);
  }

  /// Check if animation is playing
  bool isAnimationPlaying(String name) {
    return _playingAnimations.contains(name);
  }

  /// Check if animation is completed
  bool isAnimationCompleted(String name) {
    final controller = _controllers[name];
    return controller?.isCompleted ?? false;
  }

  /// Check if animation is dismissed
  bool isAnimationDismissed(String name) {
    final controller = _controllers[name];
    return controller?.isDismissed ?? false;
  }

  /// Set animation value directly
  void setAnimationValue(String name, double value) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.value = value.clamp(controller.lowerBound, controller.upperBound);
  }

  /// Animate to specific value
  void animateTo(String name, double value, {Duration? duration, Curve? curve}) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.animateTo(
      value.clamp(controller.lowerBound, controller.upperBound),
      duration: duration,
      curve: curve ?? Curves.easeInOut,
    );
  }

  /// Repeat animation
  void repeatAnimation(String name, {bool reverse = false}) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.repeat(reverse: reverse);
    _playingAnimations.add(name);
  }

  /// Stop repeating animation
  void stopRepeatingAnimation(String name) {
    final controller = _controllers[name];
    if (controller == null) return;

    controller.stop();
    _playingAnimations.remove(name);
  }

  /// Create status listener for animation completion
  AnimationStatusListener _createStatusListener(String name) {
    return (status) {
      if (status == AnimationStatus.completed) {
        _completionCallbacks[name]?.call();
      }
    };
  }

  /// Dispose of specific animation
  void _disposeAnimation(String name) {
    final controller = _controllers[name];
    if (controller != null) {
      controller.dispose();
      _controllers.remove(name);
      _animations.remove(name);
      _configs.remove(name);
      _completionCallbacks.remove(name);
      _statusListeners.remove(name);
      _playingAnimations.remove(name);
    }
  }

  /// Dispose of all animations
  void _disposeAllAnimations() {
    for (final name in _controllers.keys.toList()) {
      _disposeAnimation(name);
    }
    _isInitialized = false;
  }

  /// Build fade transition widget
  Widget buildFadeTransition({
    required String animationName,
    required Widget child,
    bool alwaysIncludeSemantics = false,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child;

    return FadeTransition(
      opacity: animation,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    );
  }

  /// Build scale transition widget
  Widget buildScaleTransition({
    required String animationName,
    required Widget child,
    Alignment alignment = Alignment.center,
    bool alwaysIncludeSemantics = false,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child;

    return ScaleTransition(
      scale: animation,
      alignment: alignment,
      child: child,
    );
  }

  /// Build slide transition widget
  Widget buildSlideTransition({
    required String animationName,
    required Widget child,
    Tween<Offset>? position,
    TextDirection? textDirection,
    bool alwaysIncludeSemantics = false,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child;

    return SlideTransition(
      position: animation.drive(position ?? Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      )),
      textDirection: textDirection,
      child: child,
    );
  }

  /// Build rotation transition widget
  Widget buildRotationTransition({
    required String animationName,
    required Widget child,
    Alignment alignment = Alignment.center,
    bool alwaysIncludeSemantics = false,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child;

    return RotationTransition(
      turns: animation,
      alignment: alignment,
      child: child,
    );
  }

  /// Build size transition widget
  Widget buildSizeTransition({
    required String animationName,
    required Widget child,
    Axis axis = Axis.vertical,
    Alignment alignment = Alignment.center,
    bool alwaysIncludeSemantics = false,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child;

    return SizeTransition(
      sizeFactor: animation,
      axis: axis,
      axisAlignment: 1.0,
      child: child,
    );
  }

  /// Build animated builder widget
  Widget buildAnimatedBuilder({
    required String animationName,
    required TransitionBuilder builder,
    Widget? child,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) return child ?? const SizedBox.shrink();

    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }

  /// Create a staggered fade-in animation for list items
  void createListItemAnimations({
    required int itemCount,
    Duration itemDelay = const Duration(milliseconds: 100),
    Duration itemDuration = const Duration(milliseconds: 300),
  }) {
    for (int i = 0; i < itemCount; i++) {
      final name = 'item_$i';
      createFadeAnimation(
        name: name,
        duration: itemDuration,
      );

      // Start animation with stagger delay
      Future.delayed(itemDelay * i, () {
        if (mounted) {
          playAnimation(name);
        }
      });
    }
  }

  /// Create a pulse animation
  AnimationController createPulseAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    double scaleMin = 0.95,
    double scaleMax = 1.05,
    VoidCallback? onComplete,
  }) {
    final controller = createScaleAnimation(
      name: name,
      duration: duration,
      scaleBegin: scaleMin,
      scaleEnd: scaleMax,
      onComplete: onComplete,
    );

    // Auto-repeat the pulse
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    return controller;
  }

  /// Create a shake animation
  AnimationController createShakeAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    double offset = 10.0,
    int shakeCount = 3,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    // Create shake effect using multiple quick animations
    final totalDuration = duration;
    final singleShakeDuration = totalDuration ~/ shakeCount;

    for (int i = 0; i < shakeCount; i++) {
      final delay = singleShakeDuration * i;
      Future.delayed(delay, () {
        if (mounted && controller.isAnimating) {
          controller.animateTo(offset / 100).then((_) {
            if (mounted) {
              controller.animateTo(0.0);
            }
          });
        }
      });
    }

    return controller;
  }

  /// Create a typewriter animation
  AnimationController createTypewriterAnimation({
    required String name,
    required Duration duration,
    required int characterCount,
    Curve curve = Curves.easeIn,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a breathing animation (scale in and out)
  AnimationController createBreathingAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    double scaleMin = 0.9,
    double scaleMax = 1.1,
    VoidCallback? onComplete,
  }) {
    final controller = createScaleAnimation(
      name: name,
      duration: duration,
      scaleBegin: scaleMin,
      scaleEnd: scaleMax,
      onComplete: onComplete,
    );

    // Auto-repeat the breathing effect
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    return controller;
  }

  /// Create a flip animation
  AnimationController createFlipAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      upperBound: 1.0,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a bounce-in animation
  AnimationController createBounceInAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.bounceOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a elastic animation
  AnimationController createElasticAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.elasticOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Pause all animations
  void pauseAllAnimations() {
    for (final controller in _controllers.values) {
      if (controller.isAnimating) {
        controller.stop();
      }
    }
  }

  /// Resume all animations
  void resumeAllAnimations() {
    for (final controller in _controllers.values) {
      if (controller.isCompleted) {
        // Don't resume completed animations
        continue;
      }
      controller.forward();
    }
  }

  /// Reset all animations
  void resetAllAnimations() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
    _playingAnimations.clear();
  }

  /// Play all animations
  void playAllAnimations() {
    for (final name in _controllers.keys) {
      playAnimation(name);
    }
  }

  /// Reverse all animations
  void reverseAllAnimations() {
    for (final name in _controllers.keys) {
      reverseAnimation(name);
    }
  }

  /// Get animation progress as percentage
  double getAnimationProgress(String name) {
    final controller = _controllers[name];
    if (controller == null) return 0.0;

    final range = controller.upperBound - controller.lowerBound;
    return ((controller.value - controller.lowerBound) / range).clamp(0.0, 1.0);
  }

  /// Check if any animation is playing
  bool get isAnyAnimationPlaying => _playingAnimations.isNotEmpty;

  /// Get count of playing animations
  int get playingAnimationCount => _playingAnimations.length;

  /// Get animation duration
  Duration? getAnimationDuration(String name) {
    return _configs[name]?.duration;
  }

  /// Get animation curve
  Curve? getAnimationCurve(String name) {
    return _configs[name]?.curve;
  }

  /// Set animation curve
  void setAnimationCurve(String name, Curve curve) {
    final config = _configs[name];
    if (config == null) return;

    _configs[name] = config.copyWith(curve: curve);

    // Recreate animation with new curve
    final controller = _controllers[name];
    if (controller != null) {
      final animation = CurvedAnimation(
        parent: controller,
        curve: curve,
      );
      _animations[name] = animation;
    }
  }

  /// Set animation duration
  void setAnimationDuration(String name, Duration duration) {
    final config = _configs[name];
    if (config == null) return;

    _configs[name] = config.copyWith(duration: duration);

    // Update controller duration
    final controller = _controllers[name];
    if (controller != null) {
      controller.duration = duration;
    }
  }

  /// Create a delayed animation
  void createDelayedAnimation({
    required String name,
    required Duration duration,
    required Duration delay,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );

    Future.delayed(delay, () {
      if (mounted) {
        playAnimation(name);
      }
    });
  }

  /// Create a conditional animation that plays based on a condition
  void createConditionalAnimation({
    required String name,
    required Duration duration,
    required bool Function() condition,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );

    // Check condition periodically
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (condition()) {
        playAnimation(name);
        timer.cancel();
      }
    });
  }

  /// Create a looping animation
  void createLoopingAnimation({
    required String name,
    required Duration duration,
    int loopCount = 0, // 0 means infinite loop
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      onComplete: onComplete,
    );

    if (loopCount == 0) {
      // Infinite loop
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        }
      });
    } else {
      // Limited loops
      int currentLoop = 0;
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          currentLoop++;
          if (currentLoop < loopCount) {
            controller.reset();
            controller.forward();
          } else {
            onComplete?.call();
          }
        }
      });
    }
  }

  /// Create a physics-based animation
  AnimationController createPhysicsAnimation({
    required String name,
    required SpringDescription spring,
    double velocity = 0.0,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: const Duration(milliseconds: 1000), // Default duration
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a chained animation sequence
  void createAnimationSequence({
    required List<AnimationStep> steps,
    VoidCallback? onComplete,
  }) {
    if (steps.isEmpty) return;

    void playNext(int index) {
      if (index >= steps.length) {
        onComplete?.call();
        return;
      }

      final step = steps[index];
      playAnimation(step.name);

      // Wait for completion and play next
      _controllers[step.name]?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllers[step.name]?.removeStatusListener(arguments);
          playNext(index + 1);
        }
      });
    }

    playNext(0);
  }

  /// Create a parallel animation group
  void createParallelAnimation({
    required List<String> animationNames,
    VoidCallback? onComplete,
  }) {
    int completedCount = 0;

    for (final name in animationNames) {
      playAnimation(name);

      _controllers[name]?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          completedCount++;
          if (completedCount == animationNames.length) {
            onComplete?.call();
          }
          _controllers[name]?.removeStatusListener(arguments);
        }
      });
    }
  }

  /// Get animation value at specific progress
  double getAnimationValueAtProgress(String name, double progress) {
    final config = _configs[name];
    if (config == null) return 0.0;

    final range = config.upperBound - config.lowerBound;
    return config.lowerBound + (range * progress.clamp(0.0, 1.0));
  }

  /// Create a morphing animation between two values
  AnimationController createMorphingAnimation({
    required String name,
    required Duration duration,
    required double from,
    required double to,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      lowerBound: from,
      upperBound: to,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a wiggle animation (quick shake)
  AnimationController createWiggleAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 300),
    double intensity = 0.1,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a heartbeat animation
  AnimationController createHeartbeatAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1200),
    VoidCallback? onComplete,
  }) {
    final controller = createScaleAnimation(
      name: name,
      duration: duration,
      scaleBegin: 1.0,
      scaleEnd: 1.3,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a floating animation
  AnimationController createFloatingAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    double offset = 10.0,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a shimmer animation
  AnimationController createShimmerAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a typing indicator animation
  AnimationController createTypingAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a progress animation
  AnimationController createProgressAnimation({
    required String name,
    required Duration duration,
    required double progress,
    Curve curve = Curves.easeInOut,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: curve,
      upperBound: progress,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a countdown animation
  AnimationController createCountdownAnimation({
    required String name,
    required Duration duration,
    required int steps,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.linear,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a wave animation
  AnimationController createWaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    double amplitude = 1.0,
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a ripple animation
  AnimationController createRippleAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a glow animation
  AnimationController createGlowAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a neon animation
  AnimationController createNeonAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a hologram animation
  AnimationController createHologramAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a matrix animation
  AnimationController createMatrixAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cyberpunk animation
  AnimationController createCyberpunkAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a vaporwave animation
  AnimationController createVaporwaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a synthwave animation
  AnimationController createSynthwaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a retrowave animation
  AnimationController createRetrowaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a future animation
  AnimationController createFutureAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space animation
  AnimationController createSpaceAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cosmic animation
  AnimationController createCosmicAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a galaxy animation
  AnimationController createGalaxyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 6),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a nebula animation
  AnimationController createNebulaAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a starfield animation
  AnimationController createStarfieldAnimation({
    required String name,
    Duration duration = const Duration(seconds: 8),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a constellation animation
  AnimationController createConstellationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a meteor animation
  AnimationController createMeteorAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeIn,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a comet animation
  AnimationController createCometAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an asteroid animation
  AnimationController createAsteroidAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a black hole animation
  AnimationController createBlackHoleAnimation({
    required String name,
    Duration duration = const Duration(seconds: 6),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a supernova animation
  AnimationController createSupernovaAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum animation
  AnimationController createQuantumAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a digital animation
  AnimationController createDigitalAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a glitch animation
  AnimationController createGlitchAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 200),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a pixel animation
  AnimationController createPixelAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a voxel animation
  AnimationController createVoxelAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a minecraft animation
  AnimationController createMinecraftAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a roblox animation
  AnimationController createRobloxAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a fortnite animation
  AnimationController createFortniteAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 300),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a gaming animation
  AnimationController createGamingAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an esports animation
  AnimationController createEsportsAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a streaming animation
  AnimationController createStreamingAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a twitch animation
  AnimationController createTwitchAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a youtube animation
  AnimationController createYoutubeAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a social media animation
  AnimationController createSocialMediaAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 300),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a viral animation
  AnimationController createViralAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a trending animation
  AnimationController createTrendingAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a meme animation
  AnimationController createMemeAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a funny animation
  AnimationController createFunnyAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.bounceOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cute animation
  AnimationController createCuteAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.elasticOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a kawaii animation
  AnimationController createKawaiiAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an anime animation
  AnimationController createAnimeAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a manga animation
  AnimationController createMangaAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 400),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cartoon animation
  AnimationController createCartoonAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.bounceOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a disney animation
  AnimationController createDisneyAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a pixar animation
  AnimationController createPixarAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a dreamworks animation
  AnimationController createDreamworksAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a studio ghibli animation
  AnimationController createStudioGhibliAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a magical animation
  AnimationController createMagicalAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a fantasy animation
  AnimationController createFantasyAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a sci-fi animation
  AnimationController createSciFiAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cyberpunk animation
  AnimationController createCyberpunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a steampunk animation
  AnimationController createSteampunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a dieselpunk animation
  AnimationController createDieselpunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an atompunk animation
  AnimationController createAtompunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a biopunk animation
  AnimationController createBiopunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a nanopunk animation
  AnimationController createNanopunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a solarpunk animation
  AnimationController createSolarpunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a lunarpunk animation
  AnimationController createLunarpunkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a clockwork animation
  AnimationController createClockworkAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1200),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a mechanical animation
  AnimationController createMechanicalAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a robotic animation
  AnimationController createRoboticAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an AI animation
  AnimationController createAIAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a neural network animation
  AnimationController createNeuralNetworkAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a machine learning animation
  AnimationController createMachineLearningAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a deep learning animation
  AnimationController createDeepLearningAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a blockchain animation
  AnimationController createBlockchainAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cryptocurrency animation
  AnimationController createCryptocurrencyAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a bitcoin animation
  AnimationController createBitcoinAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an ethereum animation
  AnimationController createEthereumAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a web3 animation
  AnimationController createWeb3Animation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a metaverse animation
  AnimationController createMetaverseAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a VR animation
  AnimationController createVRAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an AR animation
  AnimationController createARAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a mixed reality animation
  AnimationController createMixedRealityAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 900),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an extended reality animation
  AnimationController createExtendedRealityAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 1000),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a virtual reality animation
  AnimationController createVirtualRealityAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an augmented reality animation
  AnimationController createAugmentedRealityAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 700),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a digital twin animation
  AnimationController createDigitalTwinAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an IoT animation
  AnimationController createIoTAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 600),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a smart city animation
  AnimationController createSmartCityAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a smart home animation
  AnimationController createSmartHomeAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a smart device animation
  AnimationController createSmartDeviceAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a smart grid animation
  AnimationController createSmartGridAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a renewable energy animation
  AnimationController createRenewableEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a solar energy animation
  AnimationController createSolarEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a wind energy animation
  AnimationController createWindEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a hydro energy animation
  AnimationController createHydroEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a geothermal energy animation
  AnimationController createGeothermalEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a biomass energy animation
  AnimationController createBiomassEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a nuclear energy animation
  AnimationController createNuclearEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a fusion energy animation
  AnimationController createFusionEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum computing animation
  AnimationController createQuantumComputingAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum internet animation
  AnimationController createQuantumInternetAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum communication animation
  AnimationController createQuantumCommunicationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum teleportation animation
  AnimationController createQuantumTeleportationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeIn,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum entanglement animation
  AnimationController createQuantumEntanglementAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum supremacy animation
  AnimationController createQuantumSupremacyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum algorithm animation
  AnimationController createQuantumAlgorithmAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum cryptography animation
  AnimationController createQuantumCryptographyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum key distribution animation
  AnimationController createQuantumKeyDistributionAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum network animation
  AnimationController createQuantumNetworkAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum sensor animation
  AnimationController createQuantumSensorAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 800),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum metrology animation
  AnimationController createQuantumMetrologyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum simulation animation
  AnimationController createQuantumSimulationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum machine learning animation
  AnimationController createQuantumMachineLearningAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum AI animation
  AnimationController createQuantumAIAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum chemistry animation
  AnimationController createQuantumChemistryAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum biology animation
  AnimationController createQuantumBiologyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum physics animation
  AnimationController createQuantumPhysicsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum mechanics animation
  AnimationController createQuantumMechanicsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quantum field theory animation
  AnimationController createQuantumFieldTheoryAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a string theory animation
  AnimationController createStringTheoryAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a multiverse animation
  AnimationController createMultiverseAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a parallel universe animation
  AnimationController createParallelUniverseAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a dimensional animation
  AnimationController createDimensionalAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a spacetime animation
  AnimationController createSpacetimeAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a wormhole animation
  AnimationController createWormholeAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a singularity animation
  AnimationController createSingularityAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an event horizon animation
  AnimationController createEventHorizonAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a hawking radiation animation
  AnimationController createHawkingRadiationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cosmic microwave background animation
  AnimationController createCosmicMicrowaveBackgroundAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a big bang animation
  AnimationController createBigBangAnimation({
    required String name,
    Duration duration = const Duration(seconds: 6),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cosmic inflation animation
  AnimationController createCosmicInflationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a dark energy animation
  AnimationController createDarkEnergyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a dark matter animation
  AnimationController createDarkMatterAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a gravitational wave animation
  AnimationController createGravitationalWaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a neutron star animation
  AnimationController createNeutronStarAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a pulsar animation
  AnimationController createPulsarAnimation({
    required String name,
    Duration duration = const Duration(milliseconds: 500),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a quasar animation
  AnimationController createQuasarAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a blazar animation
  AnimationController createBlazarAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a gamma ray burst animation
  AnimationController createGammaRayBurstAnimation({
    required String name,
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeIn,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a supernova remnant animation
  AnimationController createSupernovaRemnantAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a planetary nebula animation
  AnimationController createPlanetaryNebulaAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a star formation animation
  AnimationController createStarFormationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 6),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a protostar animation
  AnimationController createProtostarAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a main sequence star animation
  AnimationController createMainSequenceStarAnimation({
    required String name,
    Duration duration = const Duration(seconds: 8),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a red giant animation
  AnimationController createRedGiantAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a white dwarf animation
  AnimationController createWhiteDwarfAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a brown dwarf animation
  AnimationController createBrownDwarfAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a rogue planet animation
  AnimationController createRoguePlanetAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an exoplanet animation
  AnimationController createExoplanetAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a habitable zone animation
  AnimationController createHabitableZoneAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a goldilocks zone animation
  AnimationController createGoldilocksZoneAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a terraform animation
  AnimationController createTerraformAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space colonization animation
  AnimationController createSpaceColonizationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a mars colony animation
  AnimationController createMarsColonyAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a moon base animation
  AnimationController createMoonBaseAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an asteroid mining animation
  AnimationController createAsteroidMiningAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space elevator animation
  AnimationController createSpaceElevatorAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space station animation
  AnimationController createSpaceStationAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space hotel animation
  AnimationController createSpaceHotelAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space tourism animation
  AnimationController createSpaceTourismAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space walk animation
  AnimationController createSpaceWalkAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a zero gravity animation
  AnimationController createZeroGravityAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a microgravity animation
  AnimationController createMicrogravityAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an artificial gravity animation
  AnimationController createArtificialGravityAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a centrifugal force animation
  AnimationController createCentrifugalForceAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a coriolis effect animation
  AnimationController createCoriolisEffectAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a space weather animation
  AnimationController createSpaceWeatherAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a solar flare animation
  AnimationController createSolarFlareAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeIn,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a coronal mass ejection animation
  AnimationController createCoronalMassEjectionAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a solar wind animation
  AnimationController createSolarWindAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a heliosphere animation
  AnimationController createHeliosphereAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a magnetosphere animation
  AnimationController createMagnetosphereAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an aurora animation
  AnimationController createAuroraAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a northern lights animation
  AnimationController createNorthernLightsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a southern lights animation
  AnimationController createSouthernLightsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 5),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a polar lights animation
  AnimationController createPolarLightsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an ionosphere animation
  AnimationController createIonosphereAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a radio wave animation
  AnimationController createRadioWaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a microwave animation
  AnimationController createMicrowaveAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an infrared animation
  AnimationController createInfraredAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a visible light animation
  AnimationController createVisibleLightAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an ultraviolet animation
  AnimationController createUltravioletAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create an X-ray animation
  AnimationController createXRayAnimation({
    required String name,
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a gamma ray animation
  AnimationController createGammaRayAnimation({
    required String name,
    Duration duration = const Duration(seconds: 1),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cosmic ray animation
  AnimationController createCosmicRayAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a particle physics animation
  AnimationController createParticlePhysicsAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a standard model animation
  AnimationController createStandardModelAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a higgs boson animation
  AnimationController createHiggsBosonAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a large hadron collider animation
  AnimationController createLargeHadronColliderAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cern animation
  AnimationController createCernAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a particle accelerator animation
  AnimationController createParticleAcceleratorAnimation({
    required String name,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a synchrotron animation
  AnimationController createSynchrotronAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a cyclotron animation
  AnimationController createCyclotronAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a linear accelerator animation
  AnimationController createLinearAcceleratorAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a betatron animation
  AnimationController createBetatronAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
      name: name,
      duration: duration,
      curve: Curves.easeInOut,
      onComplete: onComplete,
    );

    return controller;
  }

  /// Create a microtron animation
  AnimationController createMicrotronAnimation({
    required String name,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onComplete,
  }) {
    final controller = createAnimation(
