import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hotel_controller.dart';
import '../styles/app_text.dart';
import '../widget/hotel_card.dart';

class HomePage extends StatelessWidget {
  final HotelController controller = Get.put(HotelController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load default hotels when page loads
    controller.fetchDefaultHotels();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search hotels, city, or country...',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.blueAccent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              controller.fetchHotelsFromSearch(value);
            } else {
              controller.fetchDefaultHotels();
            }
          },
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 🔍 Check if search results are available
        final List hotelsToShow = controller.fetchedHotels.isNotEmpty
            ? controller.fetchedHotels
            : controller.hotels;

        if (hotelsToShow.isEmpty) {
          return const Center(
            child: AppText('No hotels found.', color: Colors.grey),
          );
        }

        return ListView.separated(
          itemCount: hotelsToShow.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final hotel = hotelsToShow[index];
            return HotelCard(
              hotel: hotel,
              onTap: () =>
                  Get.snackbar('Selected', hotel.propertyName),
            );
          },
        );
      }),
    );
  }
}
