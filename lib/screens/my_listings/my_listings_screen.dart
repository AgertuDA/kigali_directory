import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../../providers/auth_provider.dart' as ap;
import '../../models/listing.dart';
import '../../theme.dart';
import '../directory/add_listing_screen.dart';
import '../detail/detail_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<ap.AuthProvider>();
      final provider = context.read<ListingProvider>();

      provider.startListening();

      // Only start user listings if UID is available
      if (auth.user?.uid != null) {
        provider.startListeningUserListings(auth.user!.uid);
      }
    });
  }

  Future<void> _confirmDelete(BuildContext context, Listing listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Listing',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete "${listing.name}"?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success =
          await context.read<ListingProvider>().deleteListing(listing.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Listing deleted' : 'Failed to delete'),
            backgroundColor: success ? null : AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2C5364),
        elevation: 6,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddListingScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Listings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your listings',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.list_alt, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<ListingProvider>(
      builder: (_, provider, __) {
        if (provider.userListingStatus == ListingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2C5364)),
          );
        }

        final listings = provider.userListings;
        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list_alt, color: Colors.white54, size: 56),
                const SizedBox(height: 16),
                const Text(
                  'No listings yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap + to add your first listing',
                  style: TextStyle(color: Colors.white38),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddListingScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5364),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Listing'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: listings.length,
          itemBuilder: (_, i) {
            final listing = listings[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DetailScreen(listing: listing)),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_categoryIcon(listing.category),
                          color: const Color(0xFF2C5364), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.name,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                listing.category,
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: Color(0xFF2C5364)),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddListingScreen(listing: listing),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _confirmDelete(context, listing),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'Police Station':
        return Icons.local_police;
      case 'Library':
        return Icons.local_library;
      case 'Restaurant':
        return Icons.restaurant;
      case 'Café':
        return Icons.coffee;
      case 'Park':
        return Icons.park;
      case 'Tourist Attraction':
        return Icons.camera_alt;
      case 'Pharmacy':
        return Icons.medication;
      case 'School':
        return Icons.school;
      case 'Bank':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }
}
