import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/hotel_model.dart';
import '../../../styles/app_text.dart';

// 🔹 App Bar with gallery
SliverAppBar buildSliverAppBar(Hotel hotel) {
  return SliverAppBar(
    expandedHeight: 300,
    stretch: true,
    pinned: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      stretchModes: const [StretchMode.zoomBackground],
      background: buildImageGallery(hotel),
    ),
    leading: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    ),

  );
}

// 🖼 Image Gallery
Widget buildImageGallery(Hotel hotel) {
  return Stack(
    children: [
      CachedNetworkImage(
        imageUrl: hotel.propertyImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
        placeholder: (context, _) => Center(
          child: CircularProgressIndicator(color: Colors.blue[500]),
        ),
        errorWidget: (_, __, ___) => const Center(
          child: Icon(Icons.hotel, color: Colors.grey, size: 60),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
          ),
        ),
      ),

    ],
  );
}

// 🏨 Header Section
Widget buildHeaderSection(Hotel hotel) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              hotel.propertyName,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: AppText(
                    '${hotel.propertyAddress.city}, ${hotel.propertyAddress.state}, ${hotel.propertyAddress.country}',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(width: 16),
      buildRatingCard(hotel),
    ],
  );
}

// ⭐ Rating Card
Widget buildRatingCard(Hotel hotel) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.amber[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.amber.shade200),
    ),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 16, color: Colors.amber[700]),
            const SizedBox(width: 4),
            AppText(
              hotel.googleReview.overallRating.toString(),
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ],
        ),
        AppText(
          '${hotel.googleReview.totalUserRating} reviews',
          fontSize: 11,
          color: Colors.grey[600],
        ),
      ],
    ),
  );
}

// 🏷 Property Info
Widget buildPropertyInfo(Hotel hotel) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      if (hotel.propertyType.isNotEmpty)
        infoChip(hotel.propertyType, Icons.category_outlined, Colors.blue),
      if (hotel.propertyPoliciesAndAmmenities.data?.freeWifi == true)
        infoChip('Free Wi-Fi', Icons.wifi, Colors.green),
      if (hotel.propertyPoliciesAndAmmenities.data?.freeCancellation == true)
        infoChip('Free Cancellation', Icons.cancel_outlined, Colors.red),
    ],
  );
}

Widget infoChip(String text, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Flexible(child: AppText(text, color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

// 💰 Price Card
Widget buildPriceCard(Hotel hotel) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Price Details', fontWeight: FontWeight.bold),
        const SizedBox(height: 8),
        AppText(hotel.staticPrice.displayAmount,
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
        AppText('Per night (excl. taxes)', color: Colors.grey[600], fontSize: 12),
      ],
    ),
  );
}

// 📍 About Section
Widget buildAboutSection(Hotel hotel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const AppText('About This Hotel',
          fontWeight: FontWeight.bold, fontSize: 18),
      const SizedBox(height: 8),
      AppText(
        'Experience comfort and style at ${hotel.propertyName}, located in ${hotel.propertyAddress.city}.',
        color: Colors.grey[700],
        fontSize: 14,
      ),
    ],
  );
}

// 🎯 Amenities Grid
Widget buildAmenitiesGrid(Hotel hotel) {
  final amenities = [
    infoChip('24/7 Front Desk', Icons.support_agent, Colors.purple),
    infoChip('Room Service', Icons.room_service, Colors.red),
    infoChip('Swimming Pool', Icons.pool, Colors.cyan),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const AppText('Amenities',
          fontWeight: FontWeight.bold, fontSize: 18),
      const SizedBox(height: 8),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: amenities.length,
        itemBuilder: (_, i) => amenities[i],
      ),
    ],
  );
}

// 📞 Contact
Widget buildContactSection(Hotel hotel) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText('Contact & Location',
            fontWeight: FontWeight.bold, fontSize: 16),
        const SizedBox(height: 12),
        contactItem(Icons.location_on, 'Address',
            '${hotel.propertyAddress.street}, ${hotel.propertyAddress.city}'),
        const SizedBox(height: 8),
        contactItem(Icons.phone, 'Phone', '+1 555 123 4567'),
      ],
    ),
  );
}

Widget contactItem(IconData icon, String title, String subtitle) {
  return Row(
    children: [
      Icon(icon, size: 18, color: Colors.blue),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title,
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
            AppText(subtitle, color: Colors.grey[600], fontSize: 13),
          ],
        ),
      ),
    ],
  );
}

// 🎫 Bottom Booking Bar
Widget buildBookingBar(Hotel hotel) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                hotel.staticPrice.displayAmount,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              const AppText('per night', fontSize: 12, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () => Get.snackbar(
              'Booking Started',
              'Redirecting to booking page...',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            ),
            icon: const Icon(Icons.credit_card, size: 18),
            label: const Text('Book Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[500],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
