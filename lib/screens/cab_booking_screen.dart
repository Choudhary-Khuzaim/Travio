import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../core/colors.dart';
import 'payment_screen.dart';

class CabBookingScreen extends StatefulWidget {
  const CabBookingScreen({super.key});

  @override
  State<CabBookingScreen> createState() => _CabBookingScreenState();
}

class _CabBookingScreenState extends State<CabBookingScreen> {
  int selectedCabIndex = 0;
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  List<LatLng> _routePoints = [];
  List<String> _suggestions = [];
  bool _isLoadingLocation = false;
  bool _isLoadingRoute = false;
  StreamSubscription<Position>? _positionStreamSubscription;

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();

  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropoffFocusNode = FocusNode();

  final List<Map<String, dynamic>> _cabs = [
    {
      'name': 'Economy',
      'price': 'Rs. 1,250',
      'time': '3 min',
      'icon': Icons.directions_car_filled,
    },
    {
      'name': 'Premium',
      'price': 'Rs. 1,800',
      'time': '5 min',
      'icon': Icons.directions_car,
    },
    {
      'name': 'LUX',
      'price': 'Rs. 3,500',
      'time': '8 min',
      'icon': Icons.airport_shuttle,
    },
    {
      'name': 'Van',
      'price': 'Rs. 4,500',
      'time': '12 min',
      'icon': Icons.airport_shuttle_outlined,
    },
    {
      'name': 'Mini',
      'price': 'Rs. 1,000',
      'time': '2 min',
      'icon': Icons.local_taxi,
    },
  ];

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _pickupController.dispose();
    _dropoffController.dispose();
    _pickupFocusNode.dispose();
    _dropoffFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Start with a default location (e.g., London) if needed,
    // or just wait for user to click the button.
    _currentPosition = const LatLng(24.8607, 67.0011);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are disabled. Please enable the services',
            ),
          ),
        );
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied, we cannot request permissions.',
            ),
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _startLocationUpdates() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    if (_positionStreamSubscription != null) {
      // Already listening
      return;
    }

    setState(() => _isLoadingLocation = true);

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            setState(() {
              _currentPosition = LatLng(position.latitude, position.longitude);
              _isLoadingLocation = false;
            });

            _mapController.move(_currentPosition!, 15.0);
          },
          onError: (e) {
            setState(() => _isLoadingLocation = false);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error getting location updates: $e')),
              );
            }
          },
        );
  }

  Future<void> _updateRoute() async {
    if (_pickupLocation != null && _dropoffLocation != null) {
      setState(() => _isLoadingRoute = true);

      try {
        final url =
            'https://router.project-osrm.org/route/v1/driving/'
            '${_pickupLocation!.longitude},${_pickupLocation!.latitude};'
            '${_dropoffLocation!.longitude},${_dropoffLocation!.latitude}'
            '?overview=full&geometries=geojson';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['routes'] != null && data['routes'].isNotEmpty) {
            final geometry =
                data['routes'][0]['geometry']['coordinates'] as List;
            setState(() {
              _routePoints = geometry
                  .map(
                    (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()),
                  )
                  .toList();
            });

            // Zoom map to fit the entire route
            final bounds = LatLngBounds.fromPoints(_routePoints);
            Future.delayed(const Duration(milliseconds: 100), () {
              _mapController.fitCamera(
                CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 150,
                  ),
                ),
              );
            });
          }
        }
      } catch (e) {
        debugPrint('Error fetching route: $e');
        // Fallback to straight line if API fails
        setState(() {
          _routePoints = [_pickupLocation!, _dropoffLocation!];
        });
      } finally {
        setState(() => _isLoadingRoute = false);
      }
    } else {
      setState(() {
        _routePoints = [];
        _isLoadingRoute = false;
      });
    }
  }

  void _onLocationChanged(String value, bool isPickup) {
    // Mock geocoding for demonstration
    final Map<String, LatLng> mockLocs = {
      'karachi': const LatLng(24.8607, 67.0011),
      'islamabad': const LatLng(33.6844, 73.0479),
      'lahore': const LatLng(31.5204, 74.3587),
      'quetta': const LatLng(30.1798, 66.9750),
      'malir': const LatLng(24.8990, 67.1983),
      'gulshan': const LatLng(24.9180, 67.0971),
      'clifton': const LatLng(24.8142, 67.0427),
      'dha': const LatLng(24.8085, 67.0673),
      'north nazimabad': const LatLng(24.9351, 67.0435),
      'nazimabad': const LatLng(24.9080, 67.0264),
      'bahadurabad': const LatLng(24.8829, 67.0682),
      'tariq road': const LatLng(24.8724, 67.0583),
      'current location': _currentPosition ?? const LatLng(24.8607, 67.0011),
    };

    final query = value.toLowerCase().trim();
    LatLng? found;
    mockLocs.forEach((key, val) {
      if (query.contains(key)) found = val;
    });

    setState(() {
      if (isPickup) {
        _pickupLocation = found;
      } else {
        _dropoffLocation = found;
      }

      // Update suggestions if text is not empty and not an exact match
      if (value.isNotEmpty && found == null) {
        final List<String> allCities = [
          'Karachi',
          'Lahore',
          'Islamabad',
          'Quetta',
          'Peshawar',
          'Multan',
          'Faisalabad',
          'Sialkot',
          'Malir',
          'Gulshan-e-Iqbal',
          'Clifton',
          'DHA',
          'North Nazimabad',
          'Nazimabad',
          'Bahadurabad',
          'Tariq Road',
        ];
        _suggestions = allCities
            .where((c) => c.toLowerCase().contains(query))
            .toList();
      } else {
        _suggestions = [];
      }
    });

    if (found != null) {
      _mapController.move(found!, 15.0);
    }
  }

  void _triggerSearch(bool isPickup) {
    String value = isPickup ? _pickupController.text : _dropoffController.text;
    _onLocationChanged(value, isPickup);
  }

  void _searchCompleteRoute() {
    _triggerSearch(true);
    _triggerSearch(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map Background with improved visual
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _currentPosition ?? const LatLng(24.8607, 67.0011),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.travio',
                ),
                if (_currentPosition != null ||
                    _pickupLocation != null ||
                    _dropoffLocation != null)
                  MarkerLayer(
                    markers: [
                      if (_currentPosition != null && _pickupLocation == null)
                        Marker(
                          point: _currentPosition!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      if (_pickupLocation != null)
                        Marker(
                          point: _pickupLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      if (_dropoffLocation != null)
                        Marker(
                          point: _dropoffLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: <Polyline>[
                      Polyline(
                        points: _routePoints,
                        color: AppColors.primary,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Overlay to maintain the aesthetics
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white,
                    ],
                    stops: const [0, 0.4, 0.8, 1],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildRouteCard(),
                if (_suggestions.isNotEmpty &&
                    (_pickupFocusNode.hasFocus || _dropoffFocusNode.hasFocus))
                  _buildSuggestionsList(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildLocationButton(),
                  ),
                ),
                _buildBottomPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _startLocationUpdates,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _isLoadingLocation
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    color: AppColors.primary,
                    size: 24,
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms).scale();
  }

  Widget _buildRouteCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: Icons.my_location,
            color: Colors.blue,
            label: "Pickup Location",
            hint: "Current Location",
            controller: _pickupController,
            focusNode: _pickupFocusNode,
            onChanged: (v) => _onLocationChanged(v, true),
            onSearch: () => _triggerSearch(true),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 31),
            child: SizedBox(
              height: 20,
              child: CustomPaint(
                painter: DashLinePainter(
                  color: Colors.grey.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
          _buildLocationRow(
            icon: Icons.location_on,
            color: Colors.red,
            label: "Dropoff Location",
            hint: "Where to?",
            controller: _dropoffController,
            focusNode: _dropoffFocusNode,
            onChanged: (v) => _onLocationChanged(v, false),
            onSearch: () => _triggerSearch(false),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoadingRoute ? null : _searchCompleteRoute,
              icon: _isLoadingRoute
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search, size: 18),
              label: Text(
                _isLoadingRoute ? "Fetching Route..." : "Search Route",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2);
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color color,
    required String label,
    required String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    Function(String)? onChanged,
    VoidCallback? onSearch,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: (_) => onSearch?.call(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              labelText: label,
              hintText: hint,
              border: InputBorder.none,
              labelStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              hintStyle: const TextStyle(color: Colors.black26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.grey[100]),
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            title: Text(
              suggestion,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onTap: () {
              if (_pickupFocusNode.hasFocus) {
                _pickupController.text = suggestion;
                _onLocationChanged(suggestion, true);
                _pickupFocusNode.unfocus();
              } else if (_dropoffFocusNode.hasFocus) {
                _dropoffController.text = suggestion;
                _onLocationChanged(suggestion, false);
                _dropoffFocusNode.unfocus();
              }
              _updateRoute();
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Available Cabs",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: _showAllCabsModal,
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn().slideX(),
          const SizedBox(height: 16),
          _buildCabListHorizontal(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Confirm Booking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).scale(),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 500.ms);
  }

  Widget _buildCabListHorizontal() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _cabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cab = _cabs[index];
          final isSelected = selectedCabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCabIndex = index),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[200]!,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cab['icon'] as IconData,
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cab['name'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    cab['price'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white70
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAllCabsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Select a Cab",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _cabs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final cab = _cabs[index];
                  final isSelected = selectedCabIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCabIndex = index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              cab['icon'] as IconData,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cab['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${cab['time']} away",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            cab['price'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking() {
    final cab = _cabs[selectedCabIndex];
    final priceString = cab['price'] as String;
    // Remove '$' and any other non-numeric chars except dot
    final price = double.parse(priceString.replaceAll(RegExp(r'[^0-9.]'), ''));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          title: "Cab Booking - ${cab['name']}",
          amount: price,
          data: {
            'cab_name': cab['name'],
            'pickup': _pickupController.text.isEmpty
                ? "Current Location"
                : _pickupController.text,
            'dropoff': _dropoffController.text.isEmpty
                ? "Not specified"
                : _dropoffController.text,
            'est_time': cab['time'],
          },
        ),
      ),
    );
  }
}

class DashLinePainter extends CustomPainter {
  final Color color;
  DashLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
