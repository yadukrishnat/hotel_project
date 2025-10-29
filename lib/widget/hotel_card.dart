import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hotel_model.dart';
import '../styles/app_text.dart';
import '../views/hotel_details/ui/hotel_detail_page.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;

  const HotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap:   () {
      Get.to(() => HotelDetailPage(hotel: hotel));
      },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🖼 Hotel Image with better styling
                _buildHotelImage(),

                const SizedBox(width: 12),

                // 🧾 Hotel Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🏨 Hotel Name & Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppText(
                              hotel.propertyName,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildRatingBadge(),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // 📍 Location
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              '${hotel.propertyAddress.city }, ${hotel.propertyAddress.state }',
                              fontSize: 13,
                              color: Colors.grey[600],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 🏷 Property Type & Amenities
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _buildPropertyTypeChip(),
                          ..._buildAmenityChips(),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 💰 Price Section
                      _buildPriceSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🖼 Hotel Image with improved design
  Widget _buildHotelImage() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (hotel.propertyImage).isNotEmpty
                ? Image.network(
              hotel.propertyImage,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _fallbackImage(),
            )
                : _fallbackImage(),
          ),
        ),
        // Favorite button
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  // ⭐ Rating Badge
  Widget _buildRatingBadge() {
    final rating = hotel.googleReview.overallRating;
    final reviewCount = hotel.googleReview.totalUserRating ;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star,
              size: 12,
              color: Colors.amber[700]),
          const SizedBox(width: 2),
          AppText(
            rating.toString() ,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.amber[800],
          ),
          if (reviewCount > 0) ...[
            AppText(
              ' ($reviewCount)',
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ],
        ],
      ),
    );
  }

  // 🏷 Property Type Chip
  Widget _buildPropertyTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        hotel.propertyType.capitalizeFirst ?? 'Hotel',
        fontSize: 11,
        color: Colors.blue[700],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // 🎯 Amenity Chips
  List<Widget> _buildAmenityChips() {
    final amenities = <Widget>[];
    final amenityData = hotel.propertyPoliciesAndAmmenities.data;

    if (amenityData?.freeWifi == true) {
      amenities.add(_buildAmenityChip('Wi-Fi', Icons.wifi));
    }
    if (amenityData?.freeCancellation == true) {
      amenities.add(_buildAmenityChip('Free Cancel', Icons.cancel_outlined));
    }
    if (amenityData?.payAtHotel == true) {
      amenities.add(_buildAmenityChip('Pay at Hotel', Icons.payments_outlined));
    }

    return amenities;
  }

  Widget _buildAmenityChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.green[700]),
          const SizedBox(width: 2),
          AppText(
            text,
            fontSize: 10,
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // 💰 Price Section
  Widget _buildPriceSection() {
    final markedPrice = hotel.markedPrice.displayAmount;
    final staticPrice = hotel.staticPrice.displayAmount ;

    return Row(
      children: [
        // Price
        AppText(
          staticPrice,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),

        if (markedPrice != null) ...[
          const SizedBox(width: 6),
          AppText(
            markedPrice,
            fontSize: 13,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ],

        const Spacer(),

        // Book Now Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[500],
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppText(
            'Book Now',
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 🧩 Fallback Image
  Widget _fallbackImage() {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 4),
          AppText(
            'No Image',
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }



}