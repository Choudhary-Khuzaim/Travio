import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';
import 'trip_details_screen.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "My Trips",
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 20),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[400],
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 3, color: AppColors.primary),
              insets: EdgeInsets.symmetric(horizontal: 40),
            ),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            tabs: const [
              Tab(text: "Upcoming"),
              Tab(text: "Past"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTripList(_upcomingTrips),
            _buildTripList(_pastTrips, isPast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(List<Map<String, dynamic>> trips, {bool isPast = false}) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.airplane_ticket_outlined, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Text("No trips found", style: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return _buildTripCard(context, trips[index], index, isPast);
      },
    );
  }

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip, int index, bool isPast) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: trip)),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Airline & Status
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.flight_outlined, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip['airline'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(trip['flightNo'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                _buildStatusBadge(trip['status'], isPast),
              ],
            ),
          ),

          // Origin & Destination
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLocationBlock(trip['from_code'], trip['from_city'], CrossAxisAlignment.start),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.flight_takeoff_rounded, color: AppColors.primary, size: 24),
                      Text(trip['duration'], style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            _buildDot(),
                            Expanded(child: Divider(color: Colors.grey[200], thickness: 1)),
                            _buildDot(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildLocationBlock(trip['to_code'], trip['to_city'], CrossAxisAlignment.end),
              ],
            ),
          ),

          // Dashed Divider & Cutouts
          _buildTicketDivider(),

          // Footer: Date, Time, Seat, Gate
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTripInfoDetail(Icons.calendar_today_rounded, trip['date']),
                _buildTripInfoDetail(Icons.access_time_filled_rounded, trip['time']),
                _buildTripInfoDetail(Icons.event_seat_rounded, trip['seat']),
                _buildTripInfoDetail(Icons.door_front_door_rounded, trip['gate']),
              ],
            ),
          ),
        ],
      ),
      ),
    ).animate().fadeIn(delay: (index * 150).ms).slideY(begin: 0.1, duration: 600.ms);
  }

  Widget _buildLocationBlock(String code, String city, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: -1)),
        Text(city, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusBadge(String status, bool isPast) {
    Color color = isPast ? Colors.grey : AppColors.primary;
    if (status == "In Progress") color = Colors.orange;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTripInfoDetail(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 18),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildDot() => Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFE5E7EB), shape: BoxShape.circle));

  Widget _buildTicketDivider() {
    return SizedBox(
      height: 30,
      child: Stack(
        children: [
           Center(child: Container(margin: const EdgeInsets.symmetric(horizontal: 40), child: Divider(color: Colors.grey[100], thickness: 2))),
           Positioned(left: -15, top: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFF9FAFB), shape: BoxShape.circle))),
           Positioned(right: -15, top: 0, child: Container(width: 30, height: 30, decoration: const BoxDecoration(color: Color(0xFFF9FAFB), shape: BoxShape.circle))),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _upcomingTrips = [
    {
      'airline': 'Emirates',
      'flightNo': 'EK 613',
      'from_code': 'KHI',
      'from_city': 'Karachi',
      'to_code': 'DXB',
      'to_city': 'Dubai',
      'duration': '2h 15m',
      'date': 'Dec 28',
      'time': '10:30 PM',
      'seat': '12A',
      'gate': 'B4',
      'status': 'Confirmed',
    },
    {
      'airline': 'Qatar Airways',
      'flightNo': 'QR 611',
      'from_code': 'LHE',
      'from_city': 'Lahore',
      'to_code': 'DOH',
      'to_city': 'Doha',
      'duration': '3h 45m',
      'date': 'Jan 05',
      'time': '02:15 AM',
      'seat': '24F',
      'gate': 'A1',
      'status': 'Confirmed',
    },
     {
      'airline': 'PIA',
      'flightNo': 'PK 308',
      'from_code': 'KHI',
      'from_city': 'Karachi',
      'to_code': 'ISB',
      'to_city': 'Islamabad',
      'duration': '1h 50m',
      'date': 'Jan 12',
      'time': '09:00 AM',
      'seat': '08C',
      'gate': 'C2',
      'status': 'Confirmed',
    },
  ];

  static const List<Map<String, dynamic>> _pastTrips = [
    {
      'airline': 'Turkish Airlines',
      'flightNo': 'TK 709',
      'from_code': 'KHI',
      'from_city': 'Karachi',
      'to_code': 'IST',
      'to_city': 'Istanbul',
      'duration': '6h 10m',
      'date': 'Nov 12',
      'time': '05:45 AM',
      'seat': '14B',
      'gate': 'D8',
      'status': 'Completed',
    },
    {
      'airline': 'Air Arabia',
      'flightNo': 'G9 543',
      'from_code': 'SHJ',
      'from_city': 'Sharjah',
      'to_code': 'KHI',
      'to_city': 'Karachi',
      'duration': '1h 55m',
      'date': 'Oct 20',
      'time': '11:10 PM',
      'seat': '04D',
      'gate': 'F12',
      'status': 'Completed',
    },
  ];
}
