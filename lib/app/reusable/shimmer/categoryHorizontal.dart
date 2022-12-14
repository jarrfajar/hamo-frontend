import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategoryHorizontal extends StatefulWidget {
  @override
  State<ShimmerCategoryHorizontal> createState() => _ShimmerCategoryHorizontalState();
}

class _ShimmerCategoryHorizontalState extends State<ShimmerCategoryHorizontal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 230, 230, 230),
            highlightColor: Colors.white,
            child: Container(
              width: 80.0,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
