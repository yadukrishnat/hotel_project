import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/currency_controller.dart';
import '../../../controllers/hotel_controller.dart';
import '../../../styles/app_text.dart';
import '../../../widget/hotel_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HotelController controller = Get.put(HotelController());
  final CurrencyController currencyController = Get.put(CurrencyController());
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void _setupPagination() {
    scrollController.addListener(() {
      if (controller.isSearching.value &&
          !controller.isLoading.value &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
        controller.fetchHotelsFromSearch(
          controller.searchQuery.value,
          loadMore: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Initialize on first build
    controller.fetchDefaultHotels();
    currencyController.fetchINRCurrency();
    _setupPagination();

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
                  controller.fetchDefaultHotels();
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
                controller.fetchDefaultHotels();
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                controller.fetchHotelsFromSearch(value);
              } else {
                controller.clearSearch();
                controller.fetchDefaultHotels();
              }
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => Get.toNamed('/settings'),
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
                    AppText(
                      'Settings',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
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
          // 🏷️ Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => AppText(
                  controller.isSearching.value
                      ? 'Search Results'
                      : 'Recommended Hotels',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
                const SizedBox(height: 4),
                Obx(() => AppText(
                  controller.isSearching.value
                      ? '${controller.fetchedHotels.length} hotels found'
                      : 'Discover amazing places to stay',
                  fontSize: 14,
                  color: Colors.grey[600],
                )),
              ],
            ),
          ),

          // 🏨 Hotel List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.hotelsToShow.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 16),
                      AppText(
                        'Finding amazing hotels...',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ],
                  ),
                );
              }

              final hotelsToShow = controller.hotelsToShow;

              if (hotelsToShow.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hotel_outlined,
                          size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const AppText(
                        'No hotels found',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        'Try adjusting your search criteria',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (controller.isSearching.value &&
                      !controller.isLoading.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200) {
                    controller.fetchHotelsFromSearch(
                      controller.searchQuery.value,
                      loadMore: true,
                    );
                  }
                  return false;
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: hotelsToShow.length +
                      (controller.isSearching.value &&
                          controller.isLoading.value
                          ? 1
                          : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index < hotelsToShow.length) {
                      final hotel = hotelsToShow[index];
                      return HotelCard(hotel: hotel);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
