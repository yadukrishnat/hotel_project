import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/hotel_model.dart';
import '../styles/app_text.dart';


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
          SliverAppBar(
            expandedHeight: 300,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: _buildImageGallery(),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
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
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // 🏨 Hotel Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              hotel.propertyName ,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 8),
                            _buildLocationRow(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildRatingCard(),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🏷 Property Type & Amenities
                  _buildPropertyInfo(),

                  const SizedBox(height: 24),

                  // 💰 Price Section
                  _buildPriceCard(),

                  const SizedBox(height: 24),

                  // 📍 About Hotel
                  _buildAboutSection(),

                  const SizedBox(height: 24),

                  // 🎯 Amenities Grid
                  _buildAmenitiesGrid(),

                  const SizedBox(height: 24),

                  // 📞 Contact & Location
                  _buildContactSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🎫 Bottom Booking Bar
      bottomNavigationBar: _buildBookingBar(),
    );
  }

  // 🖼 Image Gallery with multiple images
  Widget _buildImageGallery() {
    return Stack(
      children: [
        // Main Image
        CachedNetworkImage(
          imageUrl: hotel.propertyImage ,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue[500],
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hotel, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text('No Image Available', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Image Counter
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const AppText(
              '1/5',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // 📍 Location Row
  Widget _buildLocationRow() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: AppText(
            '${hotel.propertyAddress.street } ${hotel.propertyAddress.city }, ${hotel.propertyAddress.state } ${hotel.propertyAddress.country }',
            fontSize: 14,
            color: Colors.grey[600],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ⭐ Rating Card
  Widget _buildRatingCard() {
    final rating = hotel.googleReview.overallRating;
    final reviewCount = hotel.googleReview.totalUserRating;

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
                rating.toString() ,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber[800],
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(
            '${reviewCount} reviews',
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  // 🏷 Property Information
  Widget _buildPropertyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildInfoChip(
              hotel.propertyType.capitalizeFirst ?? 'Hotel',
              Icons.category_outlined,
              Colors.blue,
            ),
            if (hotel.propertyPoliciesAndAmmenities.data?.freeWifi == true)
              _buildInfoChip('Free Wi-Fi', Icons.wifi, Colors.green),
            if (hotel.propertyPoliciesAndAmmenities.data?.freeCancellation == true)
              _buildInfoChip('Free Cancellation', Icons.cancel_outlined, Colors.green),
            if (hotel.propertyPoliciesAndAmmenities.data?.payAtHotel == true)
              _buildInfoChip('Pay at Hotel', Icons.payments_outlined, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          AppText(
            text,
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // 💰 Price Card
  Widget _buildPriceCard() {
    final markedPrice = hotel.markedPrice.displayAmount;
    final staticPrice = hotel.staticPrice.displayAmount ;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
       // border: Border.all(color: Colors.grey[200]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Price Details',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AppText(
                staticPrice,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              if (markedPrice != null) ...[
                const SizedBox(width: 12),
                AppText(
                  markedPrice,
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AppText(
                    'Save 20%',
                    fontSize: 10,
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            'Per night, excluding taxes & fees',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  // 📍 About Section
  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'About This Hotel',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 12),
        AppText(
          'Experience luxury and comfort at ${hotel.propertyName} '
              'Located in the heart of ${hotel.propertyAddress.city }, '
              'we offer premium amenities and exceptional service to make your stay memorable.',
          fontSize: 14,
          color: Colors.grey[700],

        ),
      ],
    );
  }

  // 🎯 Amenities Grid
  Widget _buildAmenitiesGrid() {
    final amenities = [
      if (hotel.propertyPoliciesAndAmmenities.data?.freeWifi == true)
        _buildAmenityItem('Free Wi-Fi', Icons.wifi, Colors.blue),
      if (hotel.propertyPoliciesAndAmmenities.data?.freeCancellation == true)
        _buildAmenityItem('Free Cancellation', Icons.cancel_outlined, Colors.green),
      if (hotel.propertyPoliciesAndAmmenities.data?.payAtHotel == true)
        _buildAmenityItem('Pay at Hotel', Icons.payments_outlined, Colors.orange),
      _buildAmenityItem('24/7 Front Desk', Icons.support_agent, Colors.purple),
      _buildAmenityItem('Room Service', Icons.room_service, Colors.red),
      _buildAmenityItem('Swimming Pool', Icons.pool, Colors.cyan),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Amenities',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: amenities.length,
          itemBuilder: (context, index) => amenities[index],
        ),
      ],
    );
  }

  Widget _buildAmenityItem(String text, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          AppText(
            text,
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,

          ),
        ],
      ),
    );
  }

  // 📞 Contact Section
  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
       // border: Border.all(color: Colors.grey[200]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Contact & Location',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          const SizedBox(height: 12),
          _buildContactItem(Icons.location_on_outlined, 'Address',
              '${hotel.propertyAddress.street }\n${hotel.propertyAddress.city }, ${hotel.propertyAddress.state }'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.phone_outlined, 'Phone', '+1 (555) 123-4567'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email_outlined, 'Email', 'info@hotel.com'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue[500]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              const SizedBox(height: 2),
              AppText(
                subtitle,
                fontSize: 13,
                color: Colors.grey[600],
                //lineHeight: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🎫 Bottom Booking Bar
  Widget _buildBookingBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
         // border: Border.top: BorderSide(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
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
    hotel.staticPrice.displayAmount ,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.green[700],
    ),
    AppText(
    'per night',
    fontSize: 12,
    color: Colors.grey[600],
    ),
    ],
    ),
    ),
    const SizedBox(width: 12),
    Expanded(
    flex: 2,
    child: ElevatedButton(
    onPressed: () {
    Get.snackbar(
    'Booking Started',
    'Redirecting to booking page...',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue[500],
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
    ),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.credit_card, size: 18),
    SizedBox(width: 8),
    Text(
    'Book Now',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    ],
    ),
    );
  }
}