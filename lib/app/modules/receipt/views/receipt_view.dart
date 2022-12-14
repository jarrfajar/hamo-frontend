import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:hamo/app/data/currency.dart';
import 'package:hamo/app/models/receipt.dart';
import 'package:hamo/app/reusable/shimmer/service.dart';
import 'package:intl/intl.dart';

import '../controllers/receipt_controller.dart';

class ReceiptView extends GetView<ReceiptController> {
  String transactionID = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(transactionID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'E-Receipt',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
        future: controller.getReceipt(transactionID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerService();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shrinkWrap: true,
            itemCount: controller.receipt.length,
            itemBuilder: (context, index) {
              Receipt receipt = controller.receipt[index];

              var inputFormat = DateFormat('yyyy-MM-dd');
              var inputDate = inputFormat.parse(receipt.date!);
              var outputFormat = DateFormat('dd MMM, yyyy');
              var outputDate = outputFormat.format(inputDate);

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 235, 235, 235),
                          blurRadius: 20,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListReceipt(title: 'Service', value: receipt.service!.title!),
                        const SizedBox(height: 20.0),
                        ListReceipt(title: 'Category', value: receipt.category!.name!),
                        const SizedBox(height: 20.0),
                        // ListReceipt(title: 'Workers', value: receipt.user!.name!),
                        ListReceipt(title: 'Workers', value: receipt.service!.user!.name!),
                        const SizedBox(height: 20.0),
                        ListReceipt(title: 'Date & Time', value: '$outputDate | ${receipt.time!}'),
                        const SizedBox(height: 20.0),
                        ListReceipt(title: 'Working Hours', value: '${receipt.hours!} Hours'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 235, 235, 235),
                          blurRadius: 20,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description"),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          readOnly: true,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.7,
                                color: Color(0xff7210FF),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            fillColor: const Color(0xfffafafa),
                            hintText: receipt.description!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text("Address"),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          readOnly: true,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.7,
                                color: Color(0xff7210FF),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            fillColor: const Color(0xfffafafa),
                            hintText: receipt.address!,
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 235, 235, 235),
                          blurRadius: 20,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Amout'),
                            Text(
                              CurrencyFormat.convertToIdr(int.parse(receipt.amount!)),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Color(0xff7210ff),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Invoice'),
                            Row(
                              children: [
                                Text(
                                  receipt.invoice!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(text: receipt.invoice!)).then((_) {
                                      Fluttertoast.showToast(
                                        msg: receipt.invoice!,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: const Color(0xfff1e7ff),
                                        textColor: const Color(0xff7210ff),
                                        fontSize: 16.0,
                                      );
                                    });
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 18.0,
                                    color: Color(0xff7210ff),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Status'),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xfff1e7ff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                receipt.status!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Color(0xff7210ff),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ListReceipt extends StatelessWidget {
  final String title;
  final String value;

  const ListReceipt({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
