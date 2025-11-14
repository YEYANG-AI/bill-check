import 'package:billcheck/viewmodel/banner_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerBody extends StatefulWidget {
  const BannerBody({super.key});

  @override
  State<BannerBody> createState() => _BannerBodyState();
}

class _BannerBodyState extends State<BannerBody> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerViewModel>().loadBanner();
    });
  }

  Widget _buildBannerItem(Map<String, dynamic> banner, BuildContext context) {
    final imageUrl = banner['image']?.toString() ?? '';

    // Handle different image URL formats
    String fullImageUrl = imageUrl;
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      // If it's a relative path, construct full URL
      fullImageUrl = '$imageUrl'; // Adjust base URL as needed
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageUrl.isNotEmpty
            ? Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderBanner(banner['name'] ?? 'Banner');
                },
              )
            : _buildPlaceholderBanner(banner['name'] ?? 'Banner'),
      ),
    );
  }

  Widget _buildPlaceholderBanner(String title) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 50, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('ກຳລັງໂຫຼດໂປຣໂມຊັນ...'),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'ເກີດຂໍ້ຜິດພາດ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<BannerViewModel>().loadBanner();
              },
              child: Text('ລອງໃໝ່'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: CircularProgressIndicator(color: Colors.blue));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerViewModel>(
      builder: (context, viewModel, child) {
        // Loading state
        if (viewModel.isLoading) {
          return _buildLoadingIndicator();
        }

        // Error state
        if (viewModel.hasError) {
          return _buildErrorWidget(viewModel.error);
        }

        // Success state with banners
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                aspectRatio: 16 / 9,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                pauseAutoPlayOnTouch: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: viewModel.banners.map((banner) {
                return Builder(
                  builder: (BuildContext context) {
                    return _buildBannerItem(banner, context);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: viewModel.banners.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
