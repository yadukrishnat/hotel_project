import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hotel_model.dart';
import '../styles/app_text.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;

  const HotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => Get.snackbar('Selected', hotel.propertyName),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Hotel Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: hotel.propertyImage.isNotEmpty
                  ? Image.network(
                hotel.propertyImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
                ),
              )
                  : Container(
                width: 100,
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.hotel, size: 40, color: Colors.grey),
              ),
            ),

            // 🧾 Hotel Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name
                    AppText(
                      hotel.propertyName,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 13, color: Colors.grey),
                        const SizedBox(width: 3),
                        Expanded(
                          child: AppText(
                            '${hotel.propertyAddress.city}, ${hotel.propertyAddress.state}',
                            fontSize: 12,
                            color: Colors.grey[700],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Rating and Review
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        AppText(
                          '${hotel.googleReview.overallRating} (${hotel.googleReview.totalUserRating})',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        AppText(
                          hotel.propertyType.capitalizeFirst ?? '',
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Price and discount
                    Row(
                      children: [
                        AppText(
                          hotel.markedPrice.displayAmount,
                          fontSize: 13,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                        const SizedBox(width: 6),
                        AppText(
                          hotel.staticPrice.displayAmount,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Amenities tags
                    Wrap(
                      spacing: 6,
                      runSpacing: -4,
                      children: [
                        if (hotel.propertyPoliciesAndAmmenities.data!.freeWifi)
                          _buildTag('Free Wi-Fi', Icons.wifi),
                        if (hotel.propertyPoliciesAndAmmenities.data!.freeCancellation)
                          _buildTag('Free Cancel', Icons.cancel_outlined),
                        if (hotel.propertyPoliciesAndAmmenities.data!.payAtHotel)
                          _buildTag('Pay at Hotel', Icons.payments_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // small tag widget
  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.blueAccent),
          const SizedBox(width: 3),
          AppText(
            text,
            fontSize: 11,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
