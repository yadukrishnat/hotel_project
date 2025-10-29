import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/hotel_controller.dart';
import '../../../widget/hotel_card.dart';

class HomePage extends StatelessWidget {
  final HotelController controller = Get.put(HotelController());
  final TextEditingController searchController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Load default hotels on startup
    controller.fetchDefaultHotels();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search hotels, cities, or destinations...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
              suffixIcon: Obx(() => controller.isSearching.value
                  ? IconButton(
                icon: Icon(Icons.close, color: Colors.grey[600], size: 18),
                onPressed: () {
                  searchController.clear();
                  controller.clearSearch();
                },
              )
                  : const SizedBox.shrink()),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            onChanged: (value) {
              if (value.isEmpty) {
                controller.clearSearch();
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                controller.fetchHotelsFromSearch(value);
              } else {
                controller.clearSearch();
              }
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                Get.toNamed('/settings');
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.settings, color: Colors.blue[700], size: 20),
                    const SizedBox(height: 2),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  controller.isSearching.value
                      ? 'Search Results'
                      : 'Recommended Hotels',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                )),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.isSearching.value
                      ? '${controller.fetchedHotels.length} hotels found'
                      : 'Discover amazing places to stay',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                )),
              ],
            ),
          ),

          // Hotels list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Finding amazing hotels...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final hotelsToShow = controller.isSearching.value
                  ? controller.fetchedHotels
                  : controller.hotels;

              if (hotelsToShow.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hotel_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No hotels found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search criteria',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: hotelsToShow.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final hotel = hotelsToShow[index];
                    return HotelCard(
                      hotel: hotel,
                      // onTap: () => Get.snackbar(
                      //   'Hotel Selected',
                      //   hotel.propertyName,
                      //   snackPosition: SnackPosition.BOTTOM,
                      //   backgroundColor: Colors.green,
                      //   colorText: Colors.white,
                      //   borderRadius: 12,
                      //   margin: const EdgeInsets.all(16),
                      // ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),

      // Floating action button for quick actions

    );
  }
}