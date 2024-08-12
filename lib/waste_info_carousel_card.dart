import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WasteInfoCarouselCard extends StatefulWidget {
  @override
  _WasteInfoCarouselCardState createState() => _WasteInfoCarouselCardState();
}

class _WasteInfoCarouselCardState extends State<WasteInfoCarouselCard> {
  double foodWasteKg = 0.0; // Initialize with a default value
// Loading state

  @override
  void initState() {
    _fetchWasteData();
    super.initState();
  }

  Future<void> _fetchWasteData() async {
    DateTime now = DateTime.now();
    DateTime previousDate = now.subtract(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDate);

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('food_waste')
          .doc(formattedDate)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        print('Document data: $data');

        // Convert the string value to double
        setState(() {
          foodWasteKg = double.tryParse(data['food_waste_kg'].toString()) ?? 0.0;
        });
      } else {
        print('No document found for date: $formattedDate');
        setState(() {
          foodWasteKg = 0.0; // Default to 0.0 if no document found
        });
      }
    } catch (e) {
      print('Error fetching waste data: $e');
      setState(() {
        foodWasteKg = 0.0; // Default to 0.0 in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime previousDate = now.subtract(Duration(days: 1));
    String formattedDate = DateFormat('yyyy-MM-dd').format(previousDate);

    int peopleFed = (foodWasteKg * 5).round(); // Calculate people fed

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
              image: AssetImage('assets/poverty.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$formattedDate',
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
