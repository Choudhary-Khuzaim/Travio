import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/colors.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Saved Items",
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildSavedItem(index);
        },
      ),
    );
  }

  Widget _buildSavedItem(int index) {
    final items = [
      {'title': 'Hunza Valley', 'type': 'Destination', 'image': 'assets/images/hunza.png'},
      {'title': 'Faisal Mosque', 'type': 'Attraction', 'image': 'assets/images/faisal_mosque.png'},
      {'title': 'Skardu Trip', 'type': 'Trip', 'image': 'assets/images/skardu.png'},
      {'title': 'Serena Hotel', 'type': 'Hotel', 'image': 'assets/images/serena_hotel.png'},
    ];
    
    final item = items[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: item['image']!.startsWith('http')
              ? Image.network(
                  item['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                )
              : Image.asset(
                  item['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
        ),
        title: Text(
          item['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          item['type']!,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark, color: AppColors.primary),
          onPressed: () {},
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideX();
  }
}
