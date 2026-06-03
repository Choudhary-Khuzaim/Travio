import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travio/models/destination_model.dart';
import 'package:travio/models/flight_model.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:3000/api";
    }
    // Check for Android emulator or iOS simulator
    if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2:3000/api";
    }
    return "http://localhost:3000/api";
  }

  static String? _token;
  static Map<String, dynamic>? _currentUser;

  static String? get token => _token;
  static Map<String, dynamic>? get currentUser => _currentUser;
  static bool get isLoggedIn => _token != null;

  // Initialize service, check for saved session
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _currentUser = jsonDecode(userJson);
      }
      debugPrint("ApiService initialized. Logged in: $isLoggedIn");
    } catch (e) {
      debugPrint("ApiService initialization error: $e");
    }
  }

  // Helper headers
  static Map<String, String> get _headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Authentication
  static Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message'], 'otp': data['otp']};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: _headers,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _token = data['token'];
        _currentUser = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_currentUser));

        return {'success': true};
      } else {
        return {'success': false, 'error': data['error'] ?? 'OTP verification failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _token = data['token'];
        _currentUser = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_currentUser));

        // Dynamically load data on successful login
        await getDestinations();

        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createProfile(String name, String phone, String location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/create-profile'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'location': location,
          'profile_image': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1780&auto=format&fit=crop',
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _currentUser = data['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(_currentUser));
        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Failed to create profile'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(String name, String phone, String location) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/auth/profile'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'location': location,
          'profile_image': _currentUser?['profile_image'] ?? '',
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _currentUser = data['user'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(_currentUser));
        return {'success': true, 'user': _currentUser};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Failed to update profile'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  // Destinations Catalog
  static Future<List<Destination>> getDestinations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/destinations'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['destinations'] ?? [];
        
        final List<Destination> fetched = list.map((json) => Destination.fromJson(json)).toList();
        
        if (fetched.isNotEmpty) {
          destinationsList.clear();
          destinationsList.addAll(fetched);
        }
        return destinationsList;
      }
    } catch (e) {
      debugPrint("Error fetching destinations: $e");
    }
    return destinationsList; // Return local cache/mock on error
  }

  // Flights
  static Future<List<Flight>> getFlights({String? from, String? to}) async {
    try {
      String query = '';
      if (from != null && to != null) {
        query = '?from=${Uri.encodeComponent(from)}&to=${Uri.encodeComponent(to)}';
      }
      final response = await http.get(Uri.parse('$baseUrl/flights$query'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['flights'] ?? [];
        final List<Flight> fetched = list.map((json) => Flight.fromJson(json)).toList();
        
        if (fetched.isNotEmpty) {
          mockFlights.clear();
          mockFlights.addAll(fetched);
        }
        return mockFlights;
      }
    } catch (e) {
      debugPrint("Error fetching flights: $e");
    }
    return mockFlights;
  }

  // Bookmarking
  static Future<List<Destination>> getSavedDestinations() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/saved'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['destinations'] ?? [];
        return list.map((json) => Destination.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching saved destinations: $e");
    }
    return [];
  }

  static Future<bool> toggleBookmark(String destinationId, bool isSaved) async {
    try {
      final response = isSaved
          ? await http.post(
              Uri.parse('$baseUrl/saved'),
              headers: _headers,
              body: jsonEncode({'destination_id': destinationId}),
            )
          : await http.delete(
              Uri.parse('$baseUrl/saved/$destinationId'),
              headers: _headers,
            );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error toggling bookmark: $e");
      return false;
    }
  }

  // Bookings
  static Future<bool> createBooking({
    required String type,
    required Map<String, dynamic> details,
    required double price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: _headers,
        body: jsonEncode({
          'type': type,
          'details': details,
          'price': price,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error creating booking: $e");
      return false;
    }
  }

  // Trips
  static Future<Map<String, List<Map<String, dynamic>>>> getTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final List<dynamic> upcomingRaw = data['upcoming'] ?? [];
        final List<dynamic> pastRaw = data['past'] ?? [];

        return {
          'upcoming': List<Map<String, dynamic>>.from(upcomingRaw),
          'past': List<Map<String, dynamic>>.from(pastRaw)
        };
      }
    } catch (e) {
      debugPrint("Error fetching trips: $e");
    }
    return {'upcoming': [], 'past': []};
  }
}
