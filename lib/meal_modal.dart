import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class MealModal extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;

  MealModal({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  _MealModalState createState() => _MealModalState();
}

class _MealModalState extends State<MealModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  int _selectedRating = 0;
  bool _isRated = false;
  bool _isLoading = true;
  bool _isSubmitting = false; // Track if the rating is being submitted
  String _mealData = 'No data available'; // Default message for no data

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward().then((_) {
      // Fetch data after the image spin animation completes
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    // Get the current date and format it as 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    print('Fetching data for date: $formattedDate'); // Debug statement

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .doc(formattedDate)
          .get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        var mealData = data[widget.title.toLowerCase()] ?? 'No data available';
        print('Fetched data: $mealData'); // Debug statement

        setState(() {
          _isLoading = false;
          _mealData = mealData;
        });
      } else {
        print('No document exists for the given date'); // Debug statement
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e'); // Debug statement
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRating() async {
    setState(() {
      _isSubmitting = true; // Indicate that submission is in progress
    });

    // Get the current date and format it as 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final mealRef =
          FirebaseFirestore.instance.collection('meals').doc(formattedDate);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(mealRef);

        if (!snapshot.exists) {
          throw Exception('Meal document does not exist');
        }

        // Get current ratings from the document
        List<dynamic>? ratings = snapshot.data() != null
            ? (snapshot.data() as Map<String, dynamic>)[
                '${widget.title.toLowerCase()}_ratings'] as List<dynamic>?
            : null;

        // Ensure ratings is a list of integers
        List<int> ratingList = ratings?.cast<int>() ?? [];

        // Add the new rating
        ratingList.add(_selectedRating);

        // Calculate the new average rating
        double averageRating = (ratingList.isNotEmpty
                ? ratingList.reduce((a, b) => a + b) / ratingList.length
                : 0.0)
            .toDouble();

        // Update Firestore document
        transaction.update(mealRef, {
          '${widget.title.toLowerCase()}_ratings': ratingList,
          '${widget.title.toLowerCase()}_averageRating': averageRating,
        });
      });

      print('Rating submitted successfully');
      setState(() {
        _isRated = true;
        _isSubmitting = false; // Reset submission state
      });

      // Close the modal after a short delay to allow animation
      await Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Error submitting rating: $e');
      setState(() {
        _isSubmitting = false; // Reset submission state
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: 400,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 6),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle:
                    _rotationAnimation.value * 2 * 3.14159, // Rotate the image
                child: Hero(
                  tag:
                      'hero-${widget.title.toLowerCase()}', // Same tag as in HomePage
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(widget.imagePath),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            widget.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (_isLoading)
            // Show a loading indicator while fetching data
            CircularProgressIndicator()
          else
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
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_selectedRating > 0) {
                            await _submitRating();
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      _isSubmitting
                          ? 'Submitting...'
                          : 'Submit Rating ($_selectedRating)',
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
              crossFadeState: _isRated
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),
          SizedBox(height: 8),
          Text(
            _mealData,
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
              child: Text('Close',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
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
