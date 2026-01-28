import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Music", "Food", "Sports", "Tech", "Arts"];

  final List<Map<String, dynamic>> _allEvents = [
    {
      'title': 'Lahore Eat Festival',
      'category': 'Food',
      'date': 'Jan 12-14, 2024',
      'location': 'Jinnah Garden, Lahore',
      'price': 'Rs. 2,000',
      'rating': '4.9',
      'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=2000',
      'description': 'Experience the biggest food festival in Pakistan with over 100+ stalls featuring local and international cuisines, live music, and family entertainment.',
    },
    {
      'title': 'PSL Final: Zalmi vs Kings',
      'category': 'Sports',
      'date': 'Mar 18, 2024',
      'location': 'NSK, Karachi',
      'price': 'Rs. 5,000',
      'rating': '5.0',
      'image': 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?q=80&w=2000',
      'description': 'Witness the ultimate showdown of the season. High-voltage cricket, celebrity performances, and an electric atmosphere at the National Stadium Karachi.',
    },
    {
      'title': 'Sufi Night with Abida Parveen',
      'category': 'Music',
      'date': 'Feb 5, 2024',
      'location': 'PNCA, Islamabad',
      'price': 'Rs. 12,000',
      'rating': '4.9',
      'image': 'https://images.unsplash.com/photo-1459749411177-0473ef716175?q=80&w=2000',
      'description': 'A soulful evening of Sufi Kalams and spiritual melodies with the legendary Abida Parveen. Rejuvenate your soul with the essence of Sufism.',
    },
    {
      'title': 'Pakistan Tech Summit',
      'category': 'Tech',
      'date': 'Apr 10-12, 2024',
      'location': 'Expo Center, Lahore',
      'price': 'Rs. 3,500',
      'rating': '4.7',
      'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2000',
      'description': 'Connect with the brightest minds in the tech industry. Workshops, keynote speeches, and networking opportunities for startups and professionals.',
    },
    {
      'title': 'Karachi Art Biennale',
      'category': 'Arts',
      'date': 'May 20, 2024',
      'location': 'Frere Hall, Karachi',
      'price': 'Free Entry',
      'rating': '4.8',
      'image': 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?q=80&w=2000',
      'description': 'A celebration of contemporary art featuring local and international artists. Explore stunning installations, paintings, and digital art at the historic Frere Hall.',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedCategory == "All") return _allEvents;
    return _allEvents.where((e) => e['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverToBoxAdapter(child: _buildCategoryFilters()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildEventCard(_filteredEvents[index], index),
                childCount: _filteredEvents.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text("Upcoming Events", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?q=80&w=2000',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: const Text("PAKISTAN", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  ),
                  const SizedBox(height: 8),
                  const Text("Life Is An\nEvent", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: AnimatedContainer(
              duration: 300.ms,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey[200]!),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
  }

  Widget _buildEventCard(Map<String, dynamic> event, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'event-${event['title']}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: Image.network(event['image'], height: 200, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(event['category'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(event['date'], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(event['rating'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event['location'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(event['price'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                        child: const Text("Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1);
  }
}
