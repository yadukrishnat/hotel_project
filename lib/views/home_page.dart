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
    controller.fetchHotels();

    return Scaffold(
      appBar:  AppBar(
      backgroundColor: Colors.blueAccent,
      title: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search hotels, city, state, country',
            hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
            filled: true,
            fillColor: Colors.blueAccent.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 14),
         // onChanged: (value) => controller.searchQuery.value = value,
        ),
      ),
      centerTitle: true,
    ),

    body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hotels.isEmpty) {
          return const Center(child: AppText('No hotels found.', color: Colors.grey));
        }

        return ListView.builder(
          itemCount: controller.hotels.length,
          itemBuilder: (context, index) {
            return HotelCard(
              hotel: controller.hotels[index],
              onTap: () => Get.snackbar('Clicked', controller.hotels[index].propertyName),
            );
          },
        );
      }),
    );
  }
}
