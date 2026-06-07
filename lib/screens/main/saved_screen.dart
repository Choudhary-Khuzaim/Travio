import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:travio/core/colors.dart';
import 'package:travio/models/destination_model.dart';
import 'package:travio/services/api_service.dart';
import 'package:travio/screens/details/destination_details_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Destination> _savedItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSaved();
  }

  Future<void> _fetchSaved() async {
    setState(() => _isLoading = true);
    final list = await ApiService.getSavedDestinations();
    if (mounted) {
      setState(() {
        _savedItems = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(String destId) async {
    final success = await ApiService.toggleBookmark(destId, false);
    if (!mounted) return;
    if (success) {
      setState(() {
        _savedItems.removeWhere((item) => item.id == destId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Removed from saved items"),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _savedItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_outline, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        "No saved items yet",
                        style: TextStyle(color: Colors.grey[400], fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedItems.length,
                  itemBuilder: (context, index) {
                    return _buildSavedItem(_savedItems[index], index);
                  },
                ),
    );
  }

  Widget _buildSavedItem(Destination dest, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DestinationDetailsScreen(destination: dest, heroTag: 'saved-img-${dest.id}'),
          ),
        );
      },
      child: Container(
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
            child: Hero(
              tag: 'saved-img-${dest.id}',
              child: dest.imageUrl.startsWith('http')
                  ? Image.network(
                      dest.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    )
                  : Image.asset(
                      dest.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
            ),
          ),
          title: Text(
            dest.city,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          subtitle: Text(
            dest.country,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.bookmark, color: AppColors.primary),
            onPressed: () => _removeBookmark(dest.id),
          ),
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(),
    );
  }
}
