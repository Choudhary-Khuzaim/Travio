import 'package:flutter/material.dart';
import '../core/colors.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> selectedSeats = [];

  // Mock seat layout: 6 rows, 4 columns (A, B, aisle, C, D)
  final int rows = 8;
  final int cols = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('Select Seat', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildLegend(),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(child: _buildSeatGrid()),
                  Padding(
                     padding: const EdgeInsets.only(bottom: 30),
                     child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                           minimumSize: const Size(double.infinity, 50),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: selectedSeats.isEmpty ? null : () {
                           // Mock Booking Confirmation
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('Booked seats: ${selectedSeats.join(', ')}')),
                           );
                           Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Text(selectedSeats.isEmpty ? 'Select a seat' : 'Book ${selectedSeats.length} seats'),
                     ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.white, 'Available'),
        const SizedBox(width: 20),
        _buildLegendItem(AppColors.secondary, 'Selected'),
        const SizedBox(width: 20),
        _buildLegendItem(const Color(0xFF4B5563), 'Occupied'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: color == Colors.white ? Border.all(color: Colors.white60) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildSeatGrid() {
    return ListView.builder(
      itemCount: rows,
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSeat(rowIndex, 0, 'A'),
              _buildSeat(rowIndex, 1, 'B'),
              const SizedBox(width: 20), // Aisle
              _buildSeat(rowIndex, 2, 'C'),
              _buildSeat(rowIndex, 3, 'D'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeat(int row, int col, String label) {
    bool isOccupied = (row + col) % 7 == 0; // Mock logic for occupied seats
    String seatId = '${row + 1}$label';
    bool isSelected = selectedSeats.contains(seatId);

    return GestureDetector(
      onTap: isOccupied ? null : () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatId);
          } else {
            selectedSeats.add(seatId);
          }
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isOccupied
              ? const Color(0xFF4B5563) // Occupied
              : isSelected
                  ? AppColors.secondary // Selected
                  : Colors.white, // Available
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: isSelected || isOccupied ? null : [
             BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
             ),
          ],
        ),
        child: Center(
          child: Text(
            seatId,
            style: TextStyle(
              color: isOccupied || isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
