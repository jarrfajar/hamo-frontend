import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerService extends StatefulWidget {
  @override
  State<ShimmerService> createState() => _ShimmerServiceState();
}

class _ShimmerServiceState extends State<ShimmerService> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 241, 241, 241),
                  blurRadius: 20,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Shimmer.fromColors(
                        baseColor: const Color.fromARGB(255, 230, 230, 230),
                        highlightColor: Colors.white,
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: const Color.fromARGB(255, 230, 230, 230),
                              highlightColor: Colors.white,
                              child: Container(
                                height: 20,
                                width: double.maxFinite,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Shimmer.fromColors(
                              baseColor: const Color.fromARGB(255, 230, 230, 230),
                              highlightColor: Colors.white,
                              child: Container(
                                height: 20,
                                width: double.maxFinite,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Shimmer.fromColors(
                              baseColor: const Color.fromARGB(255, 230, 230, 230),
                              highlightColor: Colors.white,
                              child: Container(
                                height: 20,
                                width: double.maxFinite,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
