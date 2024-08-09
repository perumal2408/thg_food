import 'package:flutter/material.dart';
import 'package:thg_food/carousel_widget.dart';
import 'custom_carousel_card.dart';
import 'account_page.dart';
import 'meal_modal.dart';

class HomePage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
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
          children: [
            CarouselWidget(),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showMealModal(
                        context,
                        'assets/breakfast.png',
                        'Breakfast',
                      );
                    },
                    child: CustomCarouselCard(
                      mealType:
                          'breakfast', // Use mealType instead of documentId
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _showMealModal(
                        context,
                        'assets/lunch.png',
                        'Lunch',
                      );
                    },
                    child: CustomCarouselCard(
                      mealType: 'lunch', // Use mealType instead of documentId
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _showMealModal(
                        context,
                        'assets/dinner.png',
                        'Dinner',
                      );
                    },
                    child: CustomCarouselCard(
                      mealType: 'dinner', // Use mealType instead of documentId
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
