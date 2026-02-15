import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';
import 'featured_hotels_screen.dart';
import 'hotel_details_screen.dart';
import 'hotel_booking_form_screen.dart';

class HotelBookingScreen extends StatefulWidget {
  const HotelBookingScreen({super.key});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  String _selectedCategory = "All";
  final List<String> _categories = [
    "All",
    "Top Rated",
    "Luxury",
    "Boutique",
    "Resort",
  ];

  // Booking Filters State
  String _selectedDestination = "Search cities or hotels";
  DateTimeRange? _selectedDateRange;
  int _adults = 2;
  int _children = 0;

  List<Map<String, dynamic>> _filteredFeaturedHotels = [];
  List<Map<String, dynamic>> _filteredAllHotels = [];

  @override
  void initState() {
    super.initState();
    _filteredFeaturedHotels = List.from(_featuredHotels);
    _filteredAllHotels = List.from(_allHotels);
  }

  void _filterResults() {
    setState(() {
      // Filter Featured Hotels
      _filteredFeaturedHotels = _featuredHotels.where((hotel) {
        final matchesDest =
            _selectedDestination == "Search cities or hotels" ||
            hotel['location'].toString().toLowerCase().contains(
              _selectedDestination.toLowerCase(),
            );
        final matchesCat =
            _selectedCategory == "All" ||
            (hotel['tags'] != null &&
                (hotel['tags'] as List).contains(_selectedCategory));
        return matchesDest && matchesCat;
      }).toList();

      // Filter All Hotels
      _filteredAllHotels = _allHotels.where((hotel) {
        final matchesDest =
            _selectedDestination == "Search cities or hotels" ||
            hotel['location'].toString().toLowerCase().contains(
              _selectedDestination.toLowerCase(),
            );
        final matchesCat =
            _selectedCategory == "All" ||
            (hotel['tags'] != null &&
                (hotel['tags'] as List).contains(_selectedCategory));
        return matchesDest && matchesCat;
      }).toList();
    });
  }

  String get _dateRangeText {
    if (_selectedDateRange == null) return "Select dates";
    final start = _selectedDateRange!.start;
    final end = _selectedDateRange!.end;
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}";
  }

  String get _guestsText {
    return "$_adults Adults${_children > 0 ? ", $_children Children" : ""}";
  }

  void _showDestinationSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Popular Destinations",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children:
                    [
                      "Quetta",
                      "Islamabad",
                      "Lahore",
                      "Karachi",
                      "Skardu",
                      "Hunza Valley",
                      "Murree",
                    ].map((city) {
                      return ListTile(
                        leading: const Icon(
                          Icons.location_city,
                          color: AppColors.primary,
                        ),
                        title: Text(city),
                        onTap: () {
                          setState(() => _selectedDestination = city);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Guests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              _buildGuestCounter("Adults", "Ages 13 or above", _adults, (val) {
                setModalState(() => _adults = val);
                setState(() {});
              }),
              const SizedBox(height: 24),
              _buildGuestCounter("Children", "Ages 2 - 12", _children, (val) {
                setModalState(() => _children = val);
                setState(() {});
              }, min: 0),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestCounter(
    String title,
    String subtitle,
    int value,
    Function(int) onChanged, {
    int min = 1,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        Row(
          children: [
            _buildCounterBtn(Icons.remove, () {
              if (value > min) onChanged(value - 1);
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildCounterBtn(Icons.add, () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  final List<Map<String, dynamic>> _featuredHotels = [
    {
      'name': 'Serena Hotel',
      'location': 'Islamabad',
      'price': 'Rs. 48k',
      'rating': '4.9',
      'image': 'assets/images/serena_hotel.png',
    },
    {
      'name': 'Pearl Continental',
      'location': 'Lahore',
      'price': 'Rs. 35k',
      'rating': '4.8',
      'image': 'assets/images/pearl_continental_lahore.png',
    },
    {
      'name': 'Shangrila Skardu',
      'location': 'Kachura',
      'price': 'Rs. 42k',
      'rating': '4.9',
      'image': 'assets/images/shangrila_resort_skardu.png',
    },
    {
      'name': 'Quetta Serena Hotel',
      'location': 'Quetta, Balochistan',
      'price': 'Rs. 45k',
      'rating': '4.9',
      'image': 'assets/images/serena_hotel_quetta.png',
    },
  ];

  final List<Map<String, dynamic>> _allHotels = [
    {
      'name': 'Avari Towers',
      'location': 'Karachi, Sindh',
      'price': 'Rs. 25,000',
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=1200',
      'tags': ['Luxury', 'Top Rated'],
    },
    {
      'name': 'Monal Resort',
      'location': 'Pir Sohawa, Islamabad',
      'price': 'Rs. 18,000',
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?q=80&w=1200',
      'tags': ['Resort', 'View'],
    },
    {
      'name': 'Luxus Grand',
      'location': 'Gulberg, Lahore',
      'price': 'Rs. 22,000',
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1517840901100-8179e982ad4e?q=80&w=1200',
      'tags': ['Boutique', 'City'],
    },
    {
      'name': 'Ziarat Continental',
      'location': 'Quetta/Ziarat',
      'price': 'Rs. 15,000',
      'rating': 4.4,
      'image':
          'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?q=80&w=1200',
      'tags': ['View', 'Mountains'],
    },
    {
      'name': 'Bykea Hotel',
      'location': 'Lahore, Pakistan',
      'price': 'Rs. 5,000',
      'rating': 4.2,
      'image':
          'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?q=80&w=1200',
      'tags': ['Budget'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: CustomScrollView(
        slivers: [
          // 1. Immersive Hero Header
          _buildUltraHeroHeader(),

          // 2. Floating Interaction Card & Main Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, 0), // Removed negative pull
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    _buildFloatingSearchCard(),
                    const SizedBox(height: 32),
                    _buildFeaturedCarousel(),
                    const SizedBox(height: 32),
                    _buildCategoryFilters(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),

          // 3. Main Hotel List
          if (_filteredAllHotels.isEmpty && _filteredFeaturedHotels.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      "No results in $_selectedDestination",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Try changing your search or category",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildPremiumHotelCard(
                    _filteredAllHotels[index],
                    index,
                  );
                }, childCount: _filteredAllHotels.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUltraHeroHeader() {
    return SliverAppBar(
      expandedHeight: 260, // Reduced height for better balance
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 20),
        title: const Text(
          "Luxury Stays",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=1600',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            // Decorative elements
            Positioned(
              top: 80,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "PAKISTAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Experience\nElegance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Destination Input
          _buildModernInput(
            Icons.location_on_outlined,
            "Where to?",
            _selectedDestination,
            onTap: _showDestinationSearch,
          ),
          const SizedBox(height: 16),
          // Dates and Guests
          Row(
            children: [
              Expanded(
                child: _buildModernInput(
                  Icons.calendar_month_outlined,
                  "Date",
                  _dateRangeText,
                  onTap: _selectDateRange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModernInput(
                  Icons.person_outline,
                  "Guests",
                  _guestsText,
                  onTap: _showGuestPicker,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _filterResults,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                shadowColor: AppColors.primary.withValues(alpha: 0.5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    "Find Best Deals",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildModernInput(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Featured Treasures",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FeaturedHotelsScreen(featuredHotels: _featuredHotels),
                    ),
                  );
                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: _filteredFeaturedHotels.isEmpty
              ? const Center(
                  child: Text(
                    "No featured results",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredFeaturedHotels.length,
                  itemBuilder: (context, index) {
                    final hotel = _filteredFeaturedHotels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HotelDetailsScreen(hotel: hotel),
                          ),
                        );
                      },
                      child:
                          Container(
                                width: 280,
                                margin: const EdgeInsets.only(right: 16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: hotel['image'].startsWith('http')
                                          ? Image.network(
                                              hotel['image'],
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              hotel['image'],
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            hotel['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white70,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                hotel['location'],
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                hotel['price'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              // Glass Rating
                                              ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 5,
                                                    sigmaY: 5,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 12,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          hotel['rating'],
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 150).ms)
                              .scale(begin: const Offset(0.9, 0.9)),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = _categories[index]);
              _filterResults();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[200]!,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
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
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPremiumHotelCard(Map<String, dynamic> hotel, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsScreen(hotel: hotel),
          ),
        );
      },
      child:
          Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                          child: Image.network(
                            hotel['image'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Glass Price Tag
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  border: Border.all(color: Colors.white30),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "${hotel['price']}/night",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "TOP RATED",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Info Section
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel['name'],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        hotel['location'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      hotel['rating'].toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.wifi,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.pool,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.restaurant,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HotelBookingFormScreen(hotel: hotel),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  "Reserve Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: (index * 100).ms + 600.ms)
              .slideY(begin: 0.1, end: 0),
    );
  }
}
