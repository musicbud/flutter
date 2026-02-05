import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Modern stepper for multi-step processes
///
/// Supports:
/// - Horizontal and vertical layouts
/// - Custom step indicators
/// - Progress tracking
/// - Step validation
///
/// Example:
/// ```dart
/// ModernStepper(
///   currentStep: 0,
///   steps: [
///     StepData(title: 'Account', content: AccountForm()),
///     StepData(title: 'Profile', content: ProfileForm()),
///     StepData(title: 'Preferences', content: PreferencesForm()),
///   ],
///   onStepContinue: () => nextStep(),
///   onStepCancel: () => previousStep(),
/// )
/// ```
class ModernStepper extends StatelessWidget {
  const ModernStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.type = StepperType.vertical,
  });

  final int currentStep;
  final List<StepData> steps;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;
  final Widget Function(BuildContext, ControlsDetails)? controlsBuilder;
  final StepperType type;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: currentStep,
      onStepTapped: onStepTapped,
      onStepContinue: onStepContinue,
      onStepCancel: onStepCancel,
      controlsBuilder: controlsBuilder,
      type: type,
      steps: steps.map((stepData) {
        final index = steps.indexOf(stepData);
        return Step(
          title: Text(stepData.title),
          subtitle: stepData.subtitle != null ? Text(stepData.subtitle!) : null,
          content: stepData.content,
          isActive: currentStep == index,
          state: _getStepState(index),
        );
      }).toList(),
    );
  }

  StepState _getStepState(int index) {
    if (index < currentStep) {
      return StepState.complete;
    } else if (index == currentStep) {
      return StepState.indexed;
    } else {
      return StepState.indexed;
    }
  }
}

/// Step data model
class StepData {
  const StepData({
    required this.title,
    required this.content,
    this.subtitle,
  });

  final String title;
  final Widget content;
  final String? subtitle;
}

/// Horizontal step progress indicator
class HorizontalStepIndicator extends StatelessWidget {
  const HorizontalStepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
  });

  final List<String> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _StepIndicatorItem(
              label: steps[i],
              stepNumber: i + 1,
              isCompleted: i < currentStep,
              isActive: i == currentStep,
              onTap: onStepTapped != null ? () => onStepTapped!(i) : null,
            ),
          ),
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingXS),
                color: i < currentStep
                    ? DesignSystem.primary
                    : DesignSystem.border,
              ),
            ),
        ],
      ],
    );
  }
}

class _StepIndicatorItem extends StatelessWidget {
  const _StepIndicatorItem({
    required this.label,
    required this.stepNumber,
    required this.isCompleted,
    required this.isActive,
    this.onTap,
  });

  final String label;
  final int stepNumber;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = isCompleted || isActive
        ? DesignSystem.primary
        : DesignSystem.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted || isActive
                  ? color
                  : Colors.transparent,
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      stepNumber.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            label,
            style: (DesignSystem.caption).copyWith(
              color: isActive ? color : DesignSystem.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Compact progress dots indicator
class DotsProgressIndicator extends StatelessWidget {
  const DotsProgressIndicator({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.dotSize = 8.0,
    this.spacing = 8.0,
  });

  final int stepCount;
  final int currentStep;
  final double dotSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(stepCount, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: index == currentStep ? dotSize * 2 : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: index <= currentStep
                  ? DesignSystem.primary
                  : DesignSystem.border,
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          ),
        );
      }),
    );
  }
}

/// Linear progress stepper
class LinearProgressStepper extends StatelessWidget {
  const LinearProgressStepper({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.height = 4.0,
    this.backgroundColor,
    this.progressColor,
  });

  final int stepCount;
  final int currentStep;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / stepCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: backgroundColor ?? DesignSystem.surfaceContainer,
            valueColor: AlwaysStoppedAnimation(
              progressColor ?? DesignSystem.primary,
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingXS),
        Text(
          'Step ${currentStep + 1} of $stepCount',
          style: DesignSystem.caption,
        ),
      ],
    );
  }
}

/// Step navigation controls
class StepControls extends StatelessWidget {
  const StepControls({
    super.key,
    required this.currentStep,
    required this.stepCount,
    this.onNext,
    this.onPrevious,
    this.onComplete,
    this.nextLabel = 'Next',
    this.previousLabel = 'Back',
    this.completeLabel = 'Complete',
  });

  final int currentStep;
  final int stepCount;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onComplete;
  final String nextLabel;
  final String previousLabel;
  final String completeLabel;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == stepCount - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentStep > 0)
          OutlinedButton.icon(
            onPressed: onPrevious,
            icon: const Icon(Icons.arrow_back),
            label: Text(previousLabel),
          )
        else
          const SizedBox.shrink(),
        ElevatedButton.icon(
          onPressed: isLastStep ? onComplete : onNext,
          icon: Icon(isLastStep ? Icons.check : Icons.arrow_forward),
          label: Text(isLastStep ? completeLabel : nextLabel),
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignSystem.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Vertical step progress with content
class VerticalStepProgress extends StatelessWidget {
  const VerticalStepProgress({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<VerticalStepData> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isCompleted = index < currentStep;
        final isActive = index == currentStep;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted || isActive
                        ? DesignSystem.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: DesignSystem.primary,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: isActive ? Colors.white : DesignSystem.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? DesignSystem.primary
                        : DesignSystem.border,
                  ),
              ],
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: (DesignSystem.bodyMedium).copyWith(
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (step.description != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        step.description!,
                        style: (DesignSystem.bodySmall).copyWith(
                          color: DesignSystem.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Vertical step data model
class VerticalStepData {
  const VerticalStepData({
    required this.title,
    this.description,
  });

  final String title;
  final String? description;
}