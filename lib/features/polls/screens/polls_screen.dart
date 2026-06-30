import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/poll_model.dart';
import '../../../core/apis/poll_api.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  List<PollModel> _polls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPolls();
  }

  Future<void> _loadPolls() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final polls = await PollApi.getPolls();
    if (mounted) {
      setState(() {
        _polls = polls;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleVote(int pollIndex, int optionIndex) async {
    final originalPoll = _polls[pollIndex];

    // Optimistic UI update
    setState(() {
      final updatedOptions = List<PollOption>.from(originalPoll.options);
      updatedOptions[optionIndex] = updatedOptions[optionIndex].copyWith(
        votes: updatedOptions[optionIndex].votes + 1,
      );
      
      _polls[pollIndex] = originalPoll.copyWith(
        options: updatedOptions,
        totalVotes: originalPoll.totalVotes + 1,
        userVotedOptionIndex: optionIndex,
      );
    });

    final errorMsg = await PollApi.vote(originalPoll.id, originalPoll.options[optionIndex].id, optionIndex);
    if (!context.mounted) return;
    
    if (errorMsg != null) {
      // Revert if failed
      setState(() {
        _polls[pollIndex] = originalPoll;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    } else {
      _loadPolls(); // Background sync correct values
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.pollsSurveys,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _polls.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPolls,
              child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _polls.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No polls available at the moment',
                      style: GoogleFonts.outfit(color: AppColors.textSecondary),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _polls.length,
                  itemBuilder: (context, index) {
                    final poll = _polls[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: poll.isExpired
                                      ? Colors.grey[200]
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  poll.isExpired ? l10n.closed : l10n.active,
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: poll.isExpired
                                        ? Colors.grey
                                        : AppColors.primary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                l10n.votesCount(poll.totalVotes),
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            poll.question,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ...List.generate(poll.options.length, (optIdx) {
                            final option = poll.options[optIdx];
                            final bool isSelected = poll.userVotedOptionIndex == optIdx;
                            final double percentage = poll.totalVotes > 0
                                ? (option.votes / poll.totalVotes)
                                : 0;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: (poll.hasUserVoted || poll.isExpired)
                                    ? null
                                    : () => _handleVote(index, optIdx),
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.grey[300]!,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                    ),
                                    if (poll.hasUserVoted || poll.isExpired)
                                      FractionallySizedBox(
                                        widthFactor: percentage,
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary.withOpacity(0.2)
                                                : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option.text,
                                              style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (poll.hasUserVoted || poll.isExpired)
                                            Text(
                                              '${(percentage * 100).toStringAsFixed(0)}%',
                                              style: GoogleFonts.outfit(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
            ),
    );
  }
}
