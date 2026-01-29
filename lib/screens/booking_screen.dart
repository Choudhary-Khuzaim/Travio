import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../core/colors.dart';
import '../widgets/ticket_widget.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Flight flight;

  const BookingScreen({super.key, required this.flight});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate validation/local processing
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              title: "Flight",
              amount: widget.flight.price,
              data: {'flightId': widget.flight.id},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Passenger Details', 
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Step Progress Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(1, 'Select', true, true),
                _buildDivider(true),
                _buildStep(2, 'Details', true, false),
                _buildDivider(false),
                _buildStep(3, 'Payment', false, false),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flight Summary Ticket
                    TicketWidget(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildLocationInfo(widget.flight.fromCode, widget.flight.fromCity),
                                Column(
                                  children: [
                                    const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 24),
                                    const SizedBox(height: 4),
                                    Text(widget.flight.duration, 
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                  ],
                                ),
                                _buildLocationInfo(widget.flight.toCode, widget.flight.toCity, isEnd: true),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildFlightDetail('Date', DateFormat('MMM d, y').format(widget.flight.departureTime)),
                                _buildFlightDetail('Flight No', 'TR-${widget.flight.id}845'),
                                _buildFlightDetail('Class', 'Business'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                    
                    const SizedBox(height: 32),
                    
                    Text(
                      'Passenger Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Form Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Full Name',
                            icon: Icons.person_outline_rounded,
                            controller: _nameController,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Please enter name' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'CNIC / Passport Number',
                            icon: Icons.badge_outlined,
                            controller: _cnicController,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Please enter ID number' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Contact Number',
                            icon: Icons.phone_android_outlined,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Please enter phone number' : null,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                    
                    const SizedBox(height: 32),
                    
                    // Price Breakdown
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price Breakdown', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                          const SizedBox(height: 16),
                          _buildPriceRow('Base Fare', 'PKR ${widget.flight.price.toStringAsFixed(0)}'),
                          const SizedBox(height: 10),
                          _buildPriceRow('Taxes & Fees', 'PKR ${(widget.flight.price * 0.1).toStringAsFixed(0)}'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          _buildPriceRow('Total Amount', 'PKR ${(widget.flight.price * 1.1).toStringAsFixed(0)}', isTotal: true),
                        ],
                      ),
                    ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text(
                    'Confirm & Pay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int number, String label, bool isCompleted, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted && !isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('$number', 
                    style: TextStyle(
                      color: isActive || isCompleted ? Colors.white : Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, 
          style: TextStyle(
            fontSize: 12,
            color: isActive || isCompleted ? AppColors.textPrimary : Colors.grey.shade400,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
          )),
      ],
    );
  }

  Widget _buildDivider(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: isActive ? AppColors.primary : Colors.grey.shade200,
    );
  }

  Widget _buildLocationInfo(String code, String city, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(code, 
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Text(city, 
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _buildFlightDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, 
          style: TextStyle(
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          )),
        Text(value, 
          style: TextStyle(
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
          )),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
