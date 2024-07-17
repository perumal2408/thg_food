import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WasteInfoCarouselCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Calculate the previous date
    DateTime now = DateTime.now();
    DateTime previousDate = now.subtract(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDate);

    // Sample data
    double foodWasteKg = 20.0;
    int peopleFed = (foodWasteKg / 1)
        .round(); // Example calculation, assuming 1 kg feeds 1 person

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                  'assets/poverty.jpg'), // Replace with your image path
              fit: BoxFit.cover, // Image fitting inside the container
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              // Linear gradient from left to right
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black, // Start with black
                      Colors.transparent, // End with transparent
                    ],
                  ),
                ),
              ),
              // Text content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      '$formattedDate', // Only the formatted date
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(200, 255, 255, 255),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'FOOD WASTE: ${foodWasteKg.toStringAsFixed(1)} kg',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(155, 1, 255, 213),
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                      ),

                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "That's enough to feed around $peopleFed people. Let's stop the waste!",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(139, 255, 255, 255),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
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
