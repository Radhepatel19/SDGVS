import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/apis/news_api.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/news_model.dart';
import 'package:share_plus/share_plus.dart';

class GoodNewsFeedScreen extends StatefulWidget {
  const GoodNewsFeedScreen({super.key});

  @override
  State<GoodNewsFeedScreen> createState() => _GoodNewsFeedScreenState();
}

class _GoodNewsFeedScreenState extends State<GoodNewsFeedScreen> {
  NewsCategory? _selectedCategory;
  List<GoodNewsItem> _newsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    final news = await NewsApi.getNews();
    if (mounted) {
      setState(() {
        _newsList = news;
        _isLoading = false;
      });
    }
  }

  List<GoodNewsItem> get _filteredNews {
    List<GoodNewsItem> filtered = _selectedCategory == null
        ? List.from(_newsList)
        : _newsList.where((item) => item.category == _selectedCategory).toList();

    // Sort by likes descending, then by date descending
    filtered.sort((a, b) {
      int likesComp = b.likes.compareTo(a.likes);
      if (likesComp != 0) return likesComp;
      return b.date.compareTo(a.date);
    });

    return filtered;
  }

  void _toggleLike(String id) {
    // Find the news item
    final index = _newsList.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final news = _newsList[index];
    final wasLiked = news.userLiked;

    // Optimistic update
    setState(() {
      _newsList[index] = news.copyWith(
        userLiked: !wasLiked,
        likes: wasLiked ? news.likes - 1 : news.likes + 1,
      );
    });

    // Sync with database
    NewsApi.toggleLike(id).then((result) {
      if (result != null && mounted) {
        setState(() {
          _newsList[index] = _newsList[index].copyWith(
            userLiked: result['liked'],
            likes: result['likes'],
          );
        });
      }
    }).catchError((_) {
      // Rollback on error
      if (mounted) {
        setState(() {
          _newsList[index] = _newsList[index].copyWith(
            userLiked: wasLiked,
            likes: news.likes,
          );
        });
      }
    });
  }

  void _shareNews(GoodNewsItem news) {
    Share.share(
      '🌟 ${news.title}\n\n${news.description}\n\nRead more on SDGVS App!',
      subject: 'Good News from our Village: ${news.title}',
    );
  }

  void _shareAllNews() {
    if (_filteredNews.isEmpty) return;

    String newsSummary = "🌟 *Latest Good News from our Village* 🌟\n\n";
    for (int i = 0; i < _filteredNews.length; i++) {
      final news = _filteredNews[i];
      newsSummary += "${i + 1}. ${news.title}\n";
    }
    newsSummary += "\nCheck out these full stories on the SDGVS App!";

    Share.share(newsSummary, subject: 'Our Village Good News Digest');
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Category',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _selectedCategory = null);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.outfit(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: NewsCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                final dummyItem = GoodNewsItem(
                  id: '',
                  title: '',
                  description: '',
                  category: category,
                  date: DateTime.now(),
                  author: '',
                );

                return FilterChip(
                  label: Text(dummyItem.categoryName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(
                      () => _selectedCategory = selected ? category : null,
                    );
                    Navigator.pop(context);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  backgroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Good News Feed',
          style: GoogleFonts.outfit(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadNews,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          IconButton(
            onPressed: _showFilterSheet,
            icon: Icon(
              Icons.filter_list_rounded,
              color: _selectedCategory != null
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: RefreshIndicator(
                  onRefresh: _loadNews,
                  child: _filteredNews.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.newspaper_rounded,
                                    size: 64,
                                    color: AppColors.textSecondary.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No news in this category yet!',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          itemCount: _filteredNews.length,
                          itemBuilder: (context, index) {
                            final news = _filteredNews[index];
                            return _buildNewsCard(news);
                          },
                        ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareAllNews,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.share_rounded, color: Colors.white),
        label: Text(
          'Share All News',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(GoodNewsItem news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image Placeholder
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: news.categoryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: Icon(
                news.categoryIcon,
                size: 60,
                color: news.categoryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: news.categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        news.categoryName.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: news.categoryColor,
                        ),
                      ),
                    ),
                    Text(
                      '${news.date.day}/${news.date.month}/${news.date.year}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  news.title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.description,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        news.author[0],
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      news.author,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _toggleLike(news.id),
                      child: Row(
                        children: [
                          Icon(
                            news.userLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: news.userLiked
                                ? Colors.red[400]
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.likes}',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _shareNews(news),
                      child: const Icon(
                        Icons.share_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
