import 'package:flutter/material.dart';

class CustomCarouselCard extends StatefulWidget {
  @override
  _CustomCarouselCardState createState() => _CustomCarouselCardState();
}

class _CustomCarouselCardState extends State<CustomCarouselCard> {
  double _currentRating = 0;
  int _numberOfRatings = 100; // Example number of people voted
  double _averageRating = 4.0; // Example average rating

  void _rateFood(double rating) {
    setState(() {
      _currentRating = rating;
    });
  }

  void _submitRating() {
    // Handle the rating submission logic here
    print('User rated: $_currentRating stars');
    // Example: Update number of ratings and average rating
    setState(() {
      _numberOfRatings += 1;
      _averageRating =
          (_averageRating * (_numberOfRatings - 1) + _currentRating) /
              _numberOfRatings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/indian-food.jpg'), // Replace with your image path
              fit: BoxFit.cover, // Image fitting inside the container
            ),
          ),
          child: Stack(
            children: [
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // Content inside the card
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top part with ratings and number of people voted
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the column vertically
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center the column horizontally
                        children: [
                          Text(
                            'Rating: ${_averageRating.toStringAsFixed(1)}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '$_numberOfRatings people voted',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
