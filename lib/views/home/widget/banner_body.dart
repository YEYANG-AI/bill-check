import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerBody extends StatefulWidget {
  const BannerBody({super.key});

  @override
  State<BannerBody> createState() => _BannerBodyState();
}

class _BannerBodyState extends State<BannerBody> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        aspectRatio: 16 / 9,
        initialPage: 0,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.amber),
              child: Text('text $i', style: TextStyle(fontSize: 16.0)),
            );
          },
        );
      }).toList(),
    );
  }
}
