class OnboardingStep {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? actionText;
  final Map<String, dynamic> metadata;
  final bool isRequired;
  final int order;

  const OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.actionText,
    this.metadata = const {},
    this.isRequired = true,
    required this.order,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      actionText: json['actionText'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      isRequired: json['isRequired'] as bool? ?? true,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'actionText': actionText,
      'metadata': metadata,
      'isRequired': isRequired,
      'order': order,
    };
  }

  OnboardingStep copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? actionText,
    Map<String, dynamic>? metadata,
    bool? isRequired,
    int? order,
  }) {
    return OnboardingStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      actionText: actionText ?? this.actionText,
      metadata: metadata ?? this.metadata,
      isRequired: isRequired ?? this.isRequired,
      order: order ?? this.order,
    );
  }
}
