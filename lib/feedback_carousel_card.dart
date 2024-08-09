import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackCarouselCard extends StatefulWidget {
  @override
  _FeedbackCarouselCardState createState() => _FeedbackCarouselCardState();
}

class _FeedbackCarouselCardState extends State<FeedbackCarouselCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitted = false;

  Future<void> _submitFeedback() async {
    final feedbackCollection =
        FirebaseFirestore.instance.collection('feedback');

    try {
      await feedbackCollection.add({
        'title': _titleController.text,
        'review': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Feedback submitted successfully');
    } catch (e) {
      print('Error submitting feedback: $e');
    }

    setState(() {
      _isSubmitted = true;
    });

    // Ensure dialog closes after animation
    await Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close dialog
    });
  }

  void _showFeedbackModal(BuildContext context) {
    setState(() {
      _isSubmitted = false; // Reset the state to show the form
      _titleController.clear();
      _reviewController.clear();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isSubmitted ? _buildSuccessMessage() : _buildFeedbackForm(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      key: ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 100),
        Icon(Icons.check_circle, color: Colors.green, size: 80),
        SizedBox(height: 20),
        Text(
          'Feedback Submitted Successfully!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeedbackForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: ValueKey('form'),
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title TextField
          TextFormField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "What's most important to know?",
              hintText: 'Title your review',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          // Review TextField
          TextFormField(
            controller: _reviewController,
            maxLength: 300,
            maxLines: 6,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Write your review',
              hintText:
                  'What did you like or dislike? What did you use this product for?',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a review';
              }
              return null;
            },
          ),
          SizedBox(height: 10),

          // Submit Button
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _submitFeedback();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFD700), // Yellow color for the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFeedbackModal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 6,
        color: Colors.transparent, // Make card background transparent
        shadowColor: Colors.black.withOpacity(0.8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(15), // Match card's border radius
            image: DecorationImage(
              image: AssetImage('assets/feedback.jpg'),
              fit: BoxFit.cover, // Cover the entire space of the container
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(
                    0.2), // Adjust opacity to make it darker or lighter
                BlendMode.darken, // Use darken blend mode
              ),
            ),
          ),
        ),
      ),
    );
  }
}
