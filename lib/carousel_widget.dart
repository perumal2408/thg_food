import 'package:flutter/material.dart';
import 'feedback_carousel_card.dart';
import 'waste_info_carousel_card.dart';

final PageController _pageController = PageController(
  viewportFraction: 0.9,
  initialPage: 0, // Start with the first card active
);

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250, // Adjust this height as needed
      color: Color.fromARGB(255, 255, 255, 255),
      child: PageView.builder(
        controller: _pageController,
        itemCount: 2, // Only two items now
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
              }
              return Center(
                child: AspectRatio(
                  aspectRatio: 18 / 9,
                  child: child,
                ),
              );
            },
            // Display different carousel cards based on the index
            child: index == 0
                ? WasteInfoCarouselCard() // Waste info card for the first item
                : FeedbackCarouselCard(), // Feedback card for the second item
          );
        },
      ),
    );
  }
}