import 'package:flutter/material.dart';
import 'carousel_widget.dart';
import 'account_page.dart';
import 'meal_modal.dart'; // Import your modal file

class HomePage extends StatelessWidget {
  void _showMealModal(BuildContext context, String imagePath, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MealModal(
          imagePath: imagePath,
          title: title,
          description: '',
        );
      },
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
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/breakfast.png'),
                          ),
                          title: Text('Breakfast'),
                          subtitle:
                              Text('Start your day with a healthy breakfast.'),
                        ),
                      ),
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
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/lunch.png'),
                          ),
                          title: Text('Lunch'),
                          subtitle: Text('Enjoy a delicious lunch.'),
                        ),
                      ),
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
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/dinner.png'),
                          ),
                          title: Text('Dinner'),
                          subtitle: Text('Relax with a delightful dinner.'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }
}
