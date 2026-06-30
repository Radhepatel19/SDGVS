import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdgvs/core/models/notice_model.dart';
import 'package:sdgvs/features/home/screens/feature_placeholder_screen.dart';
import 'package:sdgvs/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../complaints/screens/complaint_category_screen.dart';
import '../../complaints/screens/complaint_status_screen.dart';
import '../../schemes/screens/scheme_category_screen.dart';
import '../../locker/screens/document_locker_screen.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../emergency/screens/emergency_services_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../notices/screens/notice_board_screen.dart';
import '../../polls/screens/polls_screen.dart';
import '../../agriculture/screens/farmer_advisory_screen.dart';
import '../../chatbot/screens/chatbot_screen.dart';
import '../../news/screens/good_news_feed_screen.dart';
import '../../rewards/screens/leaderboard_screen.dart';
import '../../rewards/screens/certificate_screen.dart';
import '../../rewards/models/reward_winner.dart';
import '../../impact/screens/impact_dashboard_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/apis/poll_api.dart';
import '../../../core/models/poll_model.dart';
import '../../../core/apis/notice_api.dart';
import '../../../core/apis/news_api.dart';
import '../../../core/apis/rewards_api.dart';
import '../../../core/models/news_model.dart';
import '../../../core/apis/notification_api.dart';
import '../../../core/services/hive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? _user;
  List<NoticeModel> _recentNotices = [];
  List<NewsModel> _recentNews = [];
  List<RewardWinner> _winners = [];
  PollModel? _topPoll;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final isLoggedIn = await AuthService.isLoggedIn();
    final user = await AuthService.getUser();
    debugPrint("isLoggedIn: $isLoggedIn, user: ${user?.name}");

    if (!isLoggedIn || user == null) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
      return;
    }
    
    if (mounted) {
      setState(() {
        _user = user;
      });
    }

    try {
      final notices = await NoticeApi.getNotices();
      final news = await NewsApi.getNews();
      final winners = await RewardsApi.getWinners(villageId: user.villageId);
      final polls = await PollApi.getPolls();
      try {
        await NotificationApi.getNotifications();
      } catch (_) {}

      if (mounted) {
        setState(() {
          _recentNotices = notices.take(3).toList();
          _recentNews = news.take(1).toList();
          _winners = winners;
          _topPoll = polls.isNotEmpty ? polls.first : null;
        });
      }
    } catch (e) {
      debugPrint('Error loading home data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUser() async {
    final user = await AuthService.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHomeData,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeSection(),
                            const SizedBox(height: 24),
                            _buildYearlyCertificatesPreview(),
                            const SizedBox(height: 16),
                            _buildGoodNewsPreview(),
                            const SizedBox(height: 16),
                            _buildNoticeBoardPreview(),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.villageServices,
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            _buildFeatureGrid(context),
                            const SizedBox(height: 16),
                            _buildCommunityVoiceSection(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.primaryGradient,
          ),
          child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Text(
          AppLocalizations.of(context)!.home,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              ).then((_) => _loadHomeData()),
            ),
            if (HiveService.unreadNotificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${HiveService.unreadNotificationCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ).then((_) => _loadUser());
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.welcome}, ${_user?.name ?? l10n.unknownUser}!',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              _user?.village ?? l10n.villageNameFallback,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Impact Dashboard',
        'icon': Icons.insights_rounded,
        'color': const Color(0xFF6C5CE7),
      },
      {
        'title': 'Village Rewards',
        'icon': Icons.emoji_events_rounded,
        'color': const Color(0xFFFFD700),
      },
      {
        'title': 'Good News',
        'icon': Icons.auto_awesome_rounded,
        'color': const Color(0xFF20BF6B),
      },
      {
        'title': l10n.registerComplaint,
        'icon': Icons.edit_note_rounded,
        'color': const Color(0xFF45AAF2),
      },
      {
        'title': l10n.govSchemes,
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFFFD9644),
      },
      {
        'title': l10n.documentLocker,
        'icon': Icons.folder_shared_rounded,
        'color': const Color(0xFF26DE81),
      },
      {
        'title': l10n.farmerAdvisory,
        'icon': Icons.agriculture_rounded,
        'color': const Color(0xFF20BF6B),
      },
      {
        'title': l10n.helpSupport,
        'icon': Icons.support_agent_rounded,
        'color': const Color(0xFFEB3B5A),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureCard(
          context,
          feature['title'],
          feature['icon'],
          feature['color'],
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () => _navigateToFeature(context, title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFeature(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    if (title == 'Impact Dashboard') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ImpactDashboardScreen()),
      );
    } else if (title == 'Village Rewards') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
      );
    } else if (title == 'Good News') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoodNewsFeedScreen()),
      );
    } else if (title == l10n.registerComplaint) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ComplaintCategoryScreen(),
        ),
      );
    } else if (title == l10n.complaintStatus) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ComplaintStatusScreen()),
      );
    } else if (title == l10n.govSchemes) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchemeCategoryScreen()),
      );
    } else if (title == l10n.documentLocker) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocumentLockerScreen()),
      );
    } else if (title == l10n.notifications) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      ).then((_) => _loadHomeData());
    } else if (title == l10n.helpSupport) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EmergencyServicesScreen(),
        ),
      );
    } else if (title == l10n.farmerAdvisory) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FarmerAdvisoryScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeaturePlaceholderScreen(title: title),
        ),
      );
    }
  }

  Widget _buildNoticeBoardPreview() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.villageNoticeBoard,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NoticeBoardScreen(),
                  ),
                ).then((_) => _loadHomeData());
              },
              child: Text(
                l10n.viewAll,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _recentNotices.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No recent notices',
                      style: GoogleFonts.outfit(color: AppColors.textSecondary),
                    ),
                  ),
                )
              : Column(
                  children: _recentNotices.asMap().entries.map((entry) {
                    final index = entry.key;
                    final notice = entry.value;
                    Color color;
                    IconData icon;
                    String tag;

                    switch (notice.type) {
                      case NoticeType.water:
                        color = Colors.blue;
                        icon = Icons.water_drop_rounded;
                        tag = 'Water';
                        break;
                      case NoticeType.power:
                        color = Colors.orange;
                        icon = Icons.bolt_rounded;
                        tag = 'Power';
                        break;
                      case NoticeType.general:
                        color = Colors.teal;
                        icon = Icons.campaign_rounded;
                        tag = 'General';
                        break;
                    }
                    if (notice.priorityOrder == 1) {
                      color = Colors.red;
                      tag = 'Urgent';
                    }

                    return Column(
                      children: [
                        _buildNoticeItem(icon, color, notice.title, tag),
                        if (index < _recentNotices.length - 1)
                          const Divider(height: 24),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildNoticeItem(
    IconData icon,
    Color color,
    String title,
    String tag,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                tag,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
      ],
    );
  }

  Widget _buildCommunityVoiceSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.communityVoice,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PollsScreen()),
                );
              },
              child: Text(
                l10n.morePolls,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_topPoll != null) ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _topPoll!.isExpired ? l10n.closed : l10n.activePoll,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _topPoll!.question,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),
                if (_topPoll!.hasUserVoted || _topPoll!.isExpired)
                  ...List.generate(_topPoll!.options.length, (index) {
                    final option = _topPoll!.options[index];
                    final double percentage = _topPoll!.totalVotes > 0
                        ? (option.votes / _topPoll!.totalVotes)
                        : 0;
                    final bool isSelected =
                        _topPoll!.userVotedOptionIndex == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  option.text,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                '${(percentage * 100).toStringAsFixed(0)}%',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                else
                  Row(
                    children: List.generate(
                      _topPoll!.options.length > 2
                          ? 2
                          : _topPoll!.options.length,
                      (index) {
                        final option = _topPoll!.options[index];
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == 0 ? 16 : 0,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                final originalPoll = _topPoll!;

                                setState(() {
                                  final updatedOptions = List<PollOption>.from(
                                    originalPoll.options,
                                  );
                                  updatedOptions[index] = updatedOptions[index]
                                      .copyWith(
                                        votes: updatedOptions[index].votes + 1,
                                      );
                                  _topPoll = originalPoll.copyWith(
                                    options: updatedOptions,
                                    totalVotes: originalPoll.totalVotes + 1,
                                    userVotedOptionIndex: index,
                                  );
                                });

                                final errorMsg = await PollApi.vote(
                                  originalPoll.id,
                                  option.id,
                                  index,
                                );
                                if (errorMsg == null) {
                                  _loadHomeData(); // Background sync
                                } else {
                                  if (!context.mounted) return;
                                  setState(() {
                                    _topPoll = originalPoll; // Revert
                                  });
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMsg)),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                option.text,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ] else
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No active polls',
                style: GoogleFonts.outfit(color: AppColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGoodNewsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Good News Feed',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoodNewsFeedScreen(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _recentNews.isEmpty
              ? Center(
                  child: Text(
                    'No success stories yet',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoodNewsFeedScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Color(0xFF6C5CE7),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recentNews.first.category.name.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6C5CE7),
                              ),
                            ),
                            Text(
                              _recentNews.first.title,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildYearlyCertificatesPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Yearly Certificates',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
              child: Text(
                'Leaderboard',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: _winners.isEmpty
              ? Center(
                  child: Text(
                    'Winners will be announced soon',
                    style: GoogleFonts.outfit(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _winners.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildRewardWinnerCard(_winners[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRewardWinnerCard(RewardWinner winner) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CertificateScreen(winner: winner),
          ),
        );
      },
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: winner.categoryColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: winner.categoryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: winner.categoryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                winner.categoryIcon,
                color: winner.categoryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    winner.name,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    winner.achievement,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFD700),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
