/// Represents the user's answers and state throughout the Gift Finder quiz.
class GiftFinderState {
  final String? recipient;
  final String? occasion;
  final Set<String> interests;
  final String? budget;
  final bool isCompleted;

  const GiftFinderState({
    this.recipient,
    this.occasion,
    this.interests = const {},
    this.budget,
    this.isCompleted = false,
  });

  GiftFinderState copyWith({
    String? recipient,
    String? occasion,
    Set<String>? interests,
    String? budget,
    bool? isCompleted,
  }) {
    return GiftFinderState(
      recipient: recipient ?? this.recipient,
      occasion: occasion ?? this.occasion,
      interests: interests ?? this.interests,
      budget: budget ?? this.budget,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Whether the user has satisfied requirements to advance for a given step index (0-indexed: 0..3).
  bool canContinue(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return recipient != null && recipient!.isNotEmpty;
      case 1:
        return occasion != null && occasion!.isNotEmpty;
      case 2:
        return interests.isNotEmpty;
      case 3:
        return budget != null && budget!.isNotEmpty;
      default:
        return false;
    }
  }

  /// Generates a human-friendly summary subtitle for the results screen.
  /// Example: "For Mom • Birthday • Under Rs. 2,500"
  String get formattedSubtitle {
    final parts = <String>[];
    if (recipient != null && recipient!.isNotEmpty) {
      parts.add('For $recipient');
    }
    if (occasion != null && occasion!.isNotEmpty) {
      parts.add(occasion!);
    }
    if (budget != null && budget!.isNotEmpty) {
      parts.add(budget!);
    }
    return parts.join(' • ');
  }

  /// Factory for an initial blank state.
  factory GiftFinderState.initial() => const GiftFinderState();
}
