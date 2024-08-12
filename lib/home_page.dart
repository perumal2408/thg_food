import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'carousel_widget.dart';
import 'account_page.dart';
import 'meal_modal.dart';

class HomePage extends StatelessWidget {
  Stream<double> _getAverageRatingStream(String mealTitle) {
    // Format date as 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return FirebaseFirestore.instance
        .collection('meals')
        .doc(formattedDate)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          // Get the average rating, defaulting to 0.0 if not available
          double averageRating =
              data['${mealTitle.toLowerCase()}_averageRating']?.toDouble() ??
                  0.0;
          return averageRating;
        }
      }
      return 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date in a readable format
    DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'The Hindu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselWidget(),
            SizedBox(height: 20),
            Text(
              "Today's Meals",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildMealCard(context, 'assets/breakfast.png', 'Breakfast'),
                  SizedBox(height: 10),
                  _buildMealCard(context, 'assets/lunch.png', 'Lunch'),
                  SizedBox(height: 10),
                  _buildMealCard(context, 'assets/dinner.png', 'Dinner'),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildMealCard(BuildContext context, String imagePath, String title) {
  return StreamBuilder<double>(
    stream: _getAverageRatingStream(title),
    builder: (context, snapshot) {
      double averageRating = snapshot.data ?? 0.0;
      Color ratingColor = averageRating < 3 ? Colors.red : Colors.green;

      return GestureDetector(
        onTap: () {
          _showMealModal(
            context,
            imagePath,
            title,
          );
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          shadowColor: Color.fromARGB(59, 0, 0, 0).withOpacity(0.2), // Shadow color
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(111, 0, 0, 0).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 0), // Shadow in all directions
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Text(
                      averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        color: ratingColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Hero(
                      tag: 'hero-${title.toLowerCase()}', // Unique tag for each meal
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(imagePath),
                      ),
                    ),
                    title: Text(title),
                    subtitle: Text('Enjoy a delicious $title.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  void _showMealModal(BuildContext context, String imagePath, String title) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return MealModal(
            imagePath: imagePath,
            title: title,
            description: '', // Pass any additional description here if needed
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation =
              animation.drive(tween.chain(CurveTween(curve: curve)));

          var scaleTween = Tween(begin: 0.5, end: 1.0);
          var scaleAnimation =
              animation.drive(scaleTween.chain(CurveTween(curve: curve)));

          return SlideTransition(
            position: offsetAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
