import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class MealModal extends StatefulWidget {
  final String imagePath;
  final String title;

  MealModal({required this.imagePath, required this.title, required String description});

  @override
  _MealModalState createState() => _MealModalState();
}

class _MealModalState extends State<MealModal> {
  int _selectedRating = 0;
  bool _isRated = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Reduced border radius for a smaller card
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    // Get the current date and format it as 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('meals').doc(formattedDate).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No data available'));
        } else {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var mealData = data[widget.title.toLowerCase()] ?? 'No data available';

          return Container(
            width: 400,
            padding: EdgeInsets.all(16.0), // Reduced padding for a smaller card
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0), // Reduced border radius
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Slightly lighter shadow for a subtler look
                  offset: Offset(0, 6),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  radius: 80, // Reduced radius for a smaller image
                  backgroundImage: AssetImage(widget.imagePath),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 16),

                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),

                AnimatedCrossFade(
                  firstChild: StarRating(
                    rating: _selectedRating,
                    onRatingSelected: (rating) {
                      setState(() {
                        _selectedRating = rating;
                        _isRated = true;
                      });
                    },
                  ),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle rating submission
                        Navigator.of(context).pop(); // Close modal after rating
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Rate ($_selectedRating)',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  crossFadeState: _isRated ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 300),
                ),
                SizedBox(height: 8),

                Text(
                  mealData,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close modal
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Close', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingSelected;

  StarRating({required this.rating, required this.onRatingSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onRatingSelected(index + 1);
          },
        );
      }),
    );
  }
}
