import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/colors.dart';
import '../models/destination_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import 'package:geolocator/geolocator.dart';

class DestinationMapScreen extends StatefulWidget {
  final Destination destination;

  const DestinationMapScreen({super.key, required this.destination});

  @override
  State<DestinationMapScreen> createState() => _DestinationMapScreenState();
}

class _DestinationMapScreenState extends State<DestinationMapScreen> {
  late final MapController _mapController;
  double _currentZoom = 13.0;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      }
      return;
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_userLocation!, 15.0);
  }

  Future<void> _openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    final appleMapsUrl = Uri.parse("https://maps.apple.com/?daddr=$lat,$lng");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else if (await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
    } else {
      // Fallback for browser
       final browserUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
       if (await canLaunchUrl(browserUrl)) {
         await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
       } else {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch maps.')));
         }
       }
    }
  }

  void _zoomIn() {
    _currentZoom++;
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _zoomOut() {
    _currentZoom--;
    _mapController.move(_mapController.camera.center, _currentZoom);
  }

  void _recenter() {
    _currentZoom = 13.0;
    _mapController.move(
      LatLng(widget.destination.latitude, widget.destination.longitude),
      _currentZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.destination.latitude, widget.destination.longitude),
              initialZoom: _currentZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.travio',
                tileBuilder: (context, widget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.transparent, 
                      BlendMode.saturation,
                    ), // Clean raw tiles
                    child: widget,
                  );
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.destination.latitude, widget.destination.longitude),
                    width: 120,
                    height: 120,
                    child: _buildCustomMarker(),
                  ),
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                          ),
                        ),
                      ).animate().scale(curve: Curves.elasticOut),
                    ),
                ],
              ),
            ],
          ),

          // 2. Verified Map Header (Back Button)
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ).animate().slideX(begin: -1, end: 0, duration: 400.ms, curve: Curves.easeOutBack),
          ),

          // 3. Right Side Controls
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            right: 20,
            child: Column(
              children: [
                _buildMapControl(Icons.add, _zoomIn),
                const SizedBox(height: 12),
                _buildMapControl(Icons.remove, _zoomOut),
                const SizedBox(height: 12),
                _buildMapControl(Icons.my_location, _determinePosition), // Current Location
                 const SizedBox(height: 12),
                _buildMapControl(Icons.center_focus_strong, _recenter), // Recenter on Destination
              ],
            ).animate().slideX(begin: 1, end: 0, delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
          ),

          // 4. Bottom Info Card
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _buildBottomInfoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMarker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.destination.city,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.star, color: Colors.orange, size: 14),
              Text(
                widget.destination.rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ).animate().slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.location_on, color: AppColors.primary, size: 50),
            Positioned(
              top: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(widget.destination.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ).animate().scale(curve: Curves.elasticOut, duration: 1000.ms),
      ],
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildBottomInfoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.destination.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.city,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.destination.country,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        const Text(
                          "Open 24/7",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Get Directions Button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _openMap(widget.destination.latitude, widget.destination.longitude),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 10, offset: const Offset(0,4))
                        ],
                      ),
                      child: const Icon(Icons.directions, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text("Go", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary))
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1, end: 0, delay: 300.ms, duration: 500.ms, curve: Curves.easeOutBack);
  }
}
