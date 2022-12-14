import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCategory extends StatefulWidget {
  @override
  State<ShimmerCategory> createState() => _ShimmerCategoryState();
}

class _ShimmerCategoryState extends State<ShimmerCategory> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        childAspectRatio: 2 / 2,
      ),
      itemCount: 8,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        // Category category = controller.listCategory[index];
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 230, 230, 230),
              highlightColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.abc),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Shimmer.fromColors(
              baseColor: const Color.fromARGB(255, 230, 230, 230),
              highlightColor: Colors.white,
              child: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
