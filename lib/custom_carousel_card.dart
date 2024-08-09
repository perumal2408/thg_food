import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCarouselCard extends StatefulWidget {
  final String mealType;

  CustomCarouselCard({required this.mealType});

  @override
  _CustomCarouselCardState createState() => _CustomCarouselCardState();
}

class _CustomCarouselCardState extends State<CustomCarouselCard> {
  double _averageRating = 0.0;
  int _numberOfRatings = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMealData();
  }

  Future<void> _fetchMealData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .doc(widget.mealType)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        var ratingCount = data['rating_count'] ?? 0;
        var totalRating = data['total_rating'] ?? 0.0;

        setState(() {
          _numberOfRatings = ratingCount;
          _averageRating = ratingCount > 0 ? totalRating / ratingCount : 0.0;
          _isLoading = false;
        });
      } else {
        print('No document found for ${widget.mealType}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Rating: ${_averageRating.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _averageRating < 3
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                      SizedBox(height: 4),
                      _isLoading
                          ? Container()
                          : Text(
                              '$_numberOfRatings people voted',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
