class PollOption {
  final String id;
  final String text;
  final int votes;

  PollOption({required this.id, required this.text, this.votes = 0});

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      id: map['id']?.toString() ?? '',
      text: map['option_text'] ?? map['text'] ?? '',
      votes: int.tryParse(map['votes_count']?.toString() ?? map['votes']?.toString() ?? '0') ?? 0,
    );
  }

  PollOption copyWith({String? id, String? text, int? votes}) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
    );
  }
}

class PollModel {
  final String id;
  final String question;
  final List<PollOption> options;
  final int totalVotes;
  final DateTime expiryDate;
  final int? userVotedOptionIndex;

  PollModel({
    required this.id,
    required this.question,
    required this.options,
    required this.totalVotes,
    required this.expiryDate,
    this.userVotedOptionIndex,
  });

  factory PollModel.fromMap(Map<String, dynamic> map) {
    final opts = (map['options'] as List?)?.map((o) => PollOption.fromMap(o)).toList() ?? [];
    final total = opts.fold<int>(0, (sum, opt) => sum + opt.votes);
    
    return PollModel(
      id: map['id']?.toString() ?? '',
      question: map['question'] ?? '',
      options: opts,
      totalVotes: int.tryParse(map['total_votes']?.toString() ?? map['totalVotes']?.toString() ?? '') ?? (total > 0 ? total : 0),
      expiryDate: DateTime.tryParse(map['expiry_date']?.toString() ?? map['expiryDate']?.toString() ?? '') ?? DateTime.now(),
      userVotedOptionIndex: map['user_voted_option_index'] ?? map['userVotedOptionIndex'],
    );
  }

  bool get hasUserVoted => userVotedOptionIndex != null;
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  PollModel copyWith({
    String? id,
    String? question,
    List<PollOption>? options,
    int? totalVotes,
    DateTime? expiryDate,
    int? userVotedOptionIndex,
  }) {
    return PollModel(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      totalVotes: totalVotes ?? this.totalVotes,
      expiryDate: expiryDate ?? this.expiryDate,
      userVotedOptionIndex: userVotedOptionIndex ?? this.userVotedOptionIndex,
    );
  }
}
