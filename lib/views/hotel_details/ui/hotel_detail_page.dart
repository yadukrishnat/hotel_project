import 'package:flutter/material.dart';

import '../../../models/hotel_model.dart';

import '../module/detailpage_module.dart';

class HotelDetailPage extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailPage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 🔝 App Bar with Image
          buildSliverAppBar(hotel),

          // 🏨 Hotel Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderSection(hotel),
                  const SizedBox(height: 24),
                  buildPropertyInfo(hotel),
                  const SizedBox(height: 24),
                  buildPriceCard(hotel),
                  const SizedBox(height: 24),
                  buildAboutSection(hotel),
                  const SizedBox(height: 24),
                  buildAmenitiesGrid(hotel),
                  const SizedBox(height: 24),
                  buildContactSection(hotel),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🎫 Bottom Booking Bar
      bottomNavigationBar: buildBookingBar(hotel),
    );
  }
}
