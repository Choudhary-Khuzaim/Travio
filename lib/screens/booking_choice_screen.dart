import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';
import '../models/destination_model.dart';
import 'package:travio/screens/search_screen.dart'; 
import 'package:travio/screens/hotel_booking_screen.dart';
import 'package:travio/screens/cab_booking_screen.dart';
import 'package:travio/screens/travel_guide_screen.dart';

class BookingChoiceScreen extends StatelessWidget {
  final Destination destination;

  const BookingChoiceScreen({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Hero Header Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Hero(
              tag: 'destination-img-booking-${destination.id}', 
              // Using a different tag if needed, or keeping it same but risk of conflict if both screens open.
              // Actually, DestinationDetails is probably below this in stack, so standard Hero might work or conflict.
              // Let's use standard Image for now to avoid conflict or complex Hero handling across multiple pushes.
              child: Image.network(
                destination.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                   color: Colors.grey[300],
                   child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                 ),
              ),
            ),
          ),
          
          // Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),

          // 2. Main Content Sheet
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trip to ${destination.city}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Select a service to proceed with your booking.",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // 3. Grid Options
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildOptionCard(
                          context,
                          "Flights",
                          Icons.flight_takeoff,
                          Colors.blueAccent,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                        ),
                        _buildOptionCard(
                          context,
                          "Hotels",
                          Icons.hotel,
                          Colors.orangeAccent,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelBookingScreen())),
                        ),
                        _buildOptionCard(
                          context,
                          "Cabs",
                          Icons.directions_car,
                          Colors.green,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CabBookingScreen())),
                        ),
                        _buildOptionCard(
                          context,
                          "Guide",
                          Icons.map_outlined,
                          Colors.purpleAccent,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TravelGuideScreen())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 200.ms),
    );
  }
}
