import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/colors.dart';

class AttractionDetailsScreen extends StatelessWidget {
  final String attractionName;
  final String attractionImage;
  final String heroTag;
  final String? description;

  const AttractionDetailsScreen({
    super.key,
    required this.attractionName,
    required this.attractionImage,
    required this.heroTag,
    this.description,
  });

  Future<void> _shareAttraction() async {
    final text =
        "Check out $attractionName on Travio! 🌍\n\n${description ?? 'Explore this amazing place with me.'}";
    await Share.share(text);
  }

  Future<void> _openMap() async {
    final query = Uri.encodeComponent(attractionName);
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$query";
    final url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _planVisit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Amazing! $attractionName has been added to your plan."),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. Parallax Header
              SliverAppBar(
                expandedHeight: 400,
                backgroundColor: AppColors.background,
                elevation: 0,
                pinned: true,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: _shareAttraction,
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: 16,
                        top: 4,
                        bottom: 4,
                      ),
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: const Icon(
                        Icons.ios_share,
                        color: Colors.black87,
                        size: 18,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: heroTag,
                        child: attractionImage.startsWith('http')
                            ? Image.network(
                                attractionImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildErrorImage(),
                              )
                            : Image.asset(
                                attractionImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildErrorImage(),
                              ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      // Title on Image
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child:
                            Text(
                              attractionName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn().slideY(
                              begin: 0.5,
                              end: 0,
                              duration: 500.ms,
                              curve: Curves.easeOut,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Details Body
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // About Section
                        const Text(
                          "About Destination",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description ??
                              "Experience the mesmerizing beauty of $attractionName. Known for its breathtaking views and rich history, this is a must-visit spot for any traveler. Whether you are looking for adventure or tranquility, $attractionName offers an unforgettable experience.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 32),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem(Icons.star, "4.8", "Rating"),
                            _buildStatItem(Icons.access_time, "Open", "Status"),
                            _buildStatItem(Icons.map, "12km", "Distance"),
                          ],
                        ).animate().slideY(
                          begin: 0.5,
                          end: 0,
                          delay: 300.ms,
                          curve: Curves.easeOutBack,
                        ),

                        const SizedBox(height: 32),

                        // Location/Map placeholder
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=800",
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child:
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 28,
                                  ),
                                ).animate().scale(
                                  duration: 800.ms,
                                  curve: Curves.elasticOut,
                                ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 3. Premium Action Bar
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child:
                Row(
                  children: [
                    // Secondary Action: Check Map
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                      child: IconButton(
                        onPressed: _openMap,
                        icon: const Icon(
                          Icons.map_outlined,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Primary Action: Plan/Book
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _planVisit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 20),
                            SizedBox(width: 10),
                            Text(
                              "Plan Your Visit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().slideY(
                  begin: 1,
                  end: 0,
                  delay: 400.ms,
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
      ),
    );
  }
}
