import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:travio/core/colors.dart';
import 'package:travio/screens/trips/trip_details_screen.dart';
import 'package:travio/services/api_service.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  List<Map<String, dynamic>> _upcomingTrips = [];
  List<Map<String, dynamic>> _pastTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getTrips();
    if (mounted) {
      setState(() {
        _upcomingTrips = data['upcoming'] ?? [];
        _pastTrips = data['past'] ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : TabBarView(
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

    return RefreshIndicator(
      onRefresh: _fetchTrips,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return _buildTripCard(context, trips[index], index, isPast);
        },
      ),
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
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.flight_outlined, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip['airline'] ?? 'PIA', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(trip['flightNo'] ?? 'PK 308', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusBadge(trip['status'] ?? 'Confirmed', isPast),
                ],
              ),
            ),

            // Origin & Destination
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLocationBlock(trip['from_code'] ?? 'KHI', trip['from_city'] ?? 'Karachi', CrossAxisAlignment.start),
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(Icons.flight_takeoff_rounded, color: AppColors.primary, size: 24),
                        Text(trip['duration'] ?? '2h 00m', style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w500)),
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
                  _buildLocationBlock(trip['to_code'] ?? 'ISB', trip['to_city'] ?? 'Islamabad', CrossAxisAlignment.end),
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
                  _buildTripInfoDetail(Icons.calendar_today_rounded, trip['date'] ?? 'Jan 12'),
                  _buildTripInfoDetail(Icons.access_time_filled_rounded, trip['time'] ?? '10:30 PM'),
                  _buildTripInfoDetail(Icons.event_seat_rounded, trip['seat'] ?? '12A'),
                  _buildTripInfoDetail(Icons.door_front_door_rounded, trip['gate'] ?? 'A2'),
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
        color: color.withOpacity(0.1),
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
}
