import 'package:flutter/material.dart';

class FeedbackCarouselCard extends StatefulWidget {
  @override
  _FeedbackCarouselCardState createState() => _FeedbackCarouselCardState();
}

class _FeedbackCarouselCardState extends State<FeedbackCarouselCard> {
  void _showFeedbackModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: AspectRatio(
            aspectRatio: 4 / 4,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 100,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your feedback here',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the feedback submission logic here
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
