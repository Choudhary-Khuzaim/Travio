import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Recent", "Positive", "Negative"];
  late List<Map<String, dynamic>> _filteredReviews;

  @override
  void initState() {
    super.initState();
    _filteredReviews = List.from(mockReviews);
  }

  void _filterReviews(int index) {
    setState(() {
      _selectedFilterIndex = index;
      switch (index) {
        case 0: // All
          _filteredReviews = List.from(mockReviews);
          break;
        case 1: // Recent (Simulate by keeping original order as they are sorted by date)
          _filteredReviews = List.from(mockReviews);
          break;
        case 2: // Positive (Rating >= 4.5)
          _filteredReviews = mockReviews
              .where((r) => (r['rating'] as double) >= 4.5)
              .toList();
          break;
        case 3: // Negative (Rating < 4.5)
          _filteredReviews = mockReviews
              .where((r) => (r['rating'] as double) < 4.5)
              .toList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Slightly off-white for depth
      appBar: AppBar(
        title: const Text("Reviews"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Premium Rating Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "4.9",
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                5,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFD700),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Based on 2.5k reviews",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildRatingBar(5, 0.85),
                              _buildRatingBar(4, 0.10),
                              _buildRatingBar(3, 0.03),
                              _buildRatingBar(2, 0.01),
                              _buildRatingBar(1, 0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 500.ms,
                    curve: Curves.easeOutQuart,
                  ),

                  const SizedBox(height: 32),

                  // Segmented Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return GestureDetector(
                          onTap: () => _filterReviews(index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.grey[300]!,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              _filters[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Review List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ReviewItem(
                  review: _filteredReviews[index],
                  index: index,
                );
              }, childCount: _filteredReviews.length),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showWriteReviewModal,
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.edit_outlined),
        label: const Text(
          "Write a Review",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ).animate().scale(delay: 500.ms),
    );
  }

  void _showWriteReviewModal() {
    int rating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Write a Review",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Rate your experience",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () => setModalState(() => rating = index + 1),
                      icon: Icon(
                        index < rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.orange,
                        size: 40,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Share your thoughts",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "What did you like or dislike?",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      _addNewReview(rating, commentController.text);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Submit Review",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewReview(int rating, String comment) {
    final newReview = {
      'name': 'You',
      'image': 'https://i.pravatar.cc/150?img=12',
      'date': 'Just now',
      'rating': rating.toDouble(),
      'comment': comment,
    };

    setState(() {
      mockReviews.insert(0, newReview);
      _filterReviews(_selectedFilterIndex);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Review Submitted Successfully!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildRatingBar(int star, double pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "$star",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 100,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: pct,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItem extends StatefulWidget {
  final Map<String, dynamic> review;
  final int index;

  const ReviewItem({super.key, required this.review, required this.index});

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool isLiked = false;
  int helpfulCount = 12; // Mock count

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                blurRadius: 20,
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[100]!, width: 2),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.review['image']),
                      radius: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.review['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.review['date'],
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.review['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.review['comment'],
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.6,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),
              Divider(color: Colors.grey[100]),
              const SizedBox(height: 10),

              Row(
                children: [
                  _buildInteractionButton(
                    icon: isLiked
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined,
                    label:
                        "Helpful (${isLiked ? helpfulCount + 1 : helpfulCount})",
                    color: isLiked ? AppColors.primary : Colors.grey[500],
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildInteractionButton(
                    icon: Icons.chat_bubble_outline,
                    label: "Reply",
                    color: Colors.grey[500],
                    onTap: _showReplyModal,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.grey),
                    onPressed: _showOptionsModal,
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: (widget.index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color == AppColors.primary
                  ? AppColors.primary
                  : Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reply to review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Write a reply...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Post Reply"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
              title: const Text(
                "Report Review",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Review reported")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("Copy Text"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text("Share Review"),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> mockReviews = [
  {
    'name': 'Sarah Johnson',
    'image': 'https://i.pravatar.cc/150?img=5',
    'date': '2 days ago',
    'rating': 5.0,
    'comment':
        'Absolutely stunning experience! ✨ The view was breathtaking and the service was top-notch. Highly recommended for families looking for a peaceful getaway.',
  },
  {
    'name': 'Michael Chen',
    'image': 'https://i.pravatar.cc/150?img=11',
    'date': '1 week ago',
    'rating': 4.5,
    'comment':
        'Great trip overall. The hiking trails were well maintained. Food was delicious but a bit spicy for my taste. The local guide was very knowledgeable!',
  },
  {
    'name': 'Emma Davis',
    'image': 'https://i.pravatar.cc/150?img=9',
    'date': '2 weeks ago',
    'rating': 5.0,
    'comment':
        'A magical place! The bonfire night was the highlight of our trip. Will definitely come back next year with more friends.',
  },
  {
    'name': 'James Wilson',
    'image': 'https://i.pravatar.cc/150?img=3',
    'date': '3 weeks ago',
    'rating': 4.0,
    'comment':
        'Good value for money. The hotel was clean and comfortable. Transport was a bit delayed though, but the scenery made up for it.',
  },
];
