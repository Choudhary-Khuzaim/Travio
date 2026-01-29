import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';
import '../models/flight_model.dart';
import 'flight_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isMapView = false;

  // State for flight search
  String selectedFromCity = 'Karachi';
  String selectedFromCode = 'KHI';
  String selectedToCity = 'Islamabad';
  String selectedToCode = 'ISB';
  DateTime selectedDate = DateTime.now();
  int travellerCount = 1;
  int childrenCount = 0;

  final List<Map<String, dynamic>> citiesList = [
    {'city': 'Karachi', 'code': 'KHI', 'lat': 24.9065, 'lng': 67.1608},
    {'city': 'Islamabad', 'code': 'ISB', 'lat': 33.5492, 'lng': 72.8258},
    {'city': 'Lahore', 'code': 'LHE', 'lat': 31.5216, 'lng': 74.4036},
    {'city': 'Peshawar', 'code': 'PEW', 'lat': 34.0259, 'lng': 71.5801},
    {'city': 'Quetta', 'code': 'UET', 'lat': 30.2518, 'lng': 66.9321},
    {'city': 'Multan', 'code': 'MUX', 'lat': 30.2028, 'lng': 71.4218},
    {'city': 'Faisalabad', 'code': 'LYP', 'lat': 31.4278, 'lng': 73.0758},
    {'city': 'Sialkot', 'code': 'SKT', 'lat': 32.5358, 'lng': 74.3496},
    {'city': 'Skardu', 'code': 'KDU', 'lat': 35.3418, 'lng': 75.5204},
    {'city': 'Gilgit', 'code': 'GIL', 'lat': 35.9187, 'lng': 74.3297},
    {'city': 'Sukkur', 'code': 'SKZ', 'lat': 27.7258, 'lng': 68.8596},
    {'city': 'Gwadar', 'code': 'GWD', 'lat': 25.2346, 'lng': 62.3308},
    {'city': 'Chitral', 'code': 'CJL', 'lat': 35.8821, 'lng': 71.8020},
    {'city': 'Bahawalpur', 'code': 'BHV', 'lat': 29.3444, 'lng': 71.7770},
    {'city': 'Rahim Yar Khan', 'code': 'RYK', 'lat': 28.3846, 'lng': 70.2741},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showTravellerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Travellers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Adults', style: TextStyle(fontSize: 16)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (travellerCount > 1) {
                                  setState(() => travellerCount--);
                                  setModalState(() {});
                                }
                              },
                              icon: const Icon(Icons.remove, color: AppColors.primary),
                            ),
                            Text('$travellerCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () {
                                if (travellerCount < 9) {
                                  setState(() => travellerCount++);
                                  setModalState(() {});
                                }
                              },
                              icon: const Icon(Icons.add, color: AppColors.primary),
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
                      const Text('Children', style: TextStyle(fontSize: 16)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (childrenCount > 0) {
                                  setState(() => childrenCount--);
                                  setModalState(() {});
                                }
                              },
                              icon: const Icon(Icons.remove, color: AppColors.primary),
                            ),
                            Text('$childrenCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              onPressed: () {
                                if (childrenCount < 9) {
                                  setState(() => childrenCount++);
                                  setModalState(() {});
                                }
                              },
                              icon: const Icon(Icons.add, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _swapLocations() {
    setState(() {
      final tempCity = selectedFromCity;
      final tempCode = selectedFromCode;
      selectedFromCity = selectedToCity;
      selectedFromCode = selectedToCode;
      selectedToCity = tempCity;
      selectedToCode = tempCode;
    });
  }

  void _showCitySelectionModal(bool isFrom) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isFrom ? 'Select Departure City' : 'Select Destination City',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: citiesList.length,
                  itemBuilder: (context, index) {
                    final city = citiesList[index];
                    return ListTile(
                      title: Text(city['city'] as String),
                      trailing: Text(city['code'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            selectedFromCity = city['city'] as String;
                            selectedFromCode = city['code'] as String;
                          } else {
                            selectedToCity = city['city'] as String;
                            selectedToCode = city['code'] as String;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search Flights'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isMapView ? Icons.list : Icons.map,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                isMapView = !isMapView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: 'searchBar',
            child: Material(
              color: Colors.transparent,
              child: _buildSearchInputs(),
            ),
          ),
          Expanded(
            child: isMapView
                ? _buildMapView()
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(begin: const Offset(0.95, 0.95))
                : _buildFlightList(),
          ),
        ],
      ),

    );
  }



  Widget _buildSearchInputs() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // From -> To Section
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _buildLocationInput(
                    label: 'From',
                    city: selectedFromCity,
                    code: selectedFromCode,
                    icon: Icons.flight_takeoff,
                    onTap: () => _showCitySelectionModal(true),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 16),
                  _buildLocationInput(
                    label: 'To',
                    city: selectedToCity,
                    code: selectedToCode,
                    icon: Icons.flight_land,
                    onTap: () => _showCitySelectionModal(false),
                  ),
                ],
              ),
              Positioned(
                right: 24,
                child: GestureDetector(
                  onTap: _swapLocations,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.swap_vert,
                        color: AppColors.primary, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Date & Travellers Section
          Row(
            children: [
              Expanded(
                child: _buildSelectionCard(
                  label: 'Departure',
                  value: DateFormat('d MMM, y').format(selectedDate),
                  icon: Icons.calendar_today,
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSelectionCard(
                  label: 'Travellers',
                  value:
                      '${travellerCount + childrenCount} User${(travellerCount + childrenCount) > 1 ? 's' : ''}',
                  icon: Icons.person_outline,
                  onTap: _showTravellerModal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput({
    required String label,
    required String city,
    required String code,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(
                  city,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }







  Widget _buildFlightList() {
    final pakistaniFlights = mockFlights.where((flight) {
      const pakistaniAirlines = ['PIA', 'Airblue', 'SereneAir', 'AirSial'];
      final matchesRoute = flight.fromCode == selectedFromCode && flight.toCode == selectedToCode;
      return pakistaniAirlines.contains(flight.airline) && matchesRoute;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: pakistaniFlights.length,
      itemBuilder: (context, index) {
        return _buildFlightCard(pakistaniFlights[index])
            .animate()
            .fadeIn(delay: (100 * index).ms)
            .slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildFlightCard(Flight flight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailsScreen(flight: flight),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: Airline & Price
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ), // Placeholder for logo
                    child: Center(
                        child: Text(flight.airline[0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColors.primary))),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight.airline,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textPrimary)),
                      Text('Flight ${flight.id}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'PKR ${flight.price}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            // Body: Route Visualization
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Departure
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight.fromCode,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(DateFormat('hh:mm a').format(flight.departureTime),
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  // Visual Path
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(flight.duration,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 2,
                                color: const Color(0xFFE2E8F0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                      radius: 3, backgroundColor: AppColors.secondary),
                                  Transform.rotate(
                                    angle: 1.57,
                                    child: const Icon(Icons.flight,
                                        size: 20, color: AppColors.primary),
                                  ),
                                  const CircleAvatar(
                                      radius: 3, backgroundColor: AppColors.secondary),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Non-stop',
                              style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  // Arrival
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(flight.toCode,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(DateFormat('hh:mm a').format(flight.arrivalTime),
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    final fromCityData = citiesList.firstWhere(
        (c) => c['code'] == selectedFromCode,
        orElse: () => citiesList.first);
    final toCityData = citiesList.firstWhere(
        (c) => c['code'] == selectedToCode,
        orElse: () => citiesList.last);

    final fromLatLng = LatLng(fromCityData['lat'], fromCityData['lng']);
    final toLatLng = LatLng(toCityData['lat'], toCityData['lng']);

    // Calculate center and zoom
    final centerLat = (fromLatLng.latitude + toLatLng.latitude) / 2;
    final centerLng = (fromLatLng.longitude + toLatLng.longitude) / 2;

    // Calculate distance
    const Distance distance = Distance();
    final double km = distance.as(LengthUnit.Kilometer, fromLatLng, toLatLng);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(centerLat, centerLng),
                initialZoom: 5.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.travio',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline<Object>(
                      points: [fromLatLng, toLatLng],
                      strokeWidth: 4.0,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: fromLatLng,
                      width: 80,
                      height: 80,
                      child: const Column(
                        children: [
                          Icon(Icons.flight_takeoff,
                              color: AppColors.primary, size: 30),
                          Text('From',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    Marker(
                      point: toLatLng,
                      width: 80,
                      height: 80,
                      child: const Column(
                        children: [
                          Icon(Icons.flight_land,
                              color: AppColors.secondary, size: 30),
                          Text('To',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Floating Overlay for Trip Info
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$selectedFromCode → $selectedToCode',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('${km.round()} km',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isMapView = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                      ),
                    )
                  ],
                ),
              ).animate().slideY(begin: 1.0, end: 0, duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}
