// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/orderModel.dart';
import 'package:logo_commerce/Model/product.dart';
import 'package:provider/provider.dart';

import '../../../View_Model/Order_provider.dart';

class MyOrderDetails extends StatefulWidget {
  MyOrderDetails({super.key, required this.op});
  final OrderModel op;

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  List<product> Products = [];
  String? email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    Image imageFromBase64String(String base64String) {
      final decodedBytes = base64Decode(base64String);
      final image = Image.memory(decodedBytes);
      return image;
    }

    var orderProvider = Provider.of<OrderProvider>(context);

    showAlertDialog(BuildContext context, OrderModel om) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text(
          "yes",
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("Orders")
              .doc(email)
              .collection("orders")
              .doc(om.id)
              .update({"status": "canceled"}).then((value) {
            orderProvider.cancelOrder(om);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("ALERT"),
        content: const Text("Are you sure to cancel the order?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Your Order Details"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pinkAccent, Colors.red],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: imageFromBase64String(widget.op.imgUrl),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Status: ${widget.op.status}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text("Items:"),
                                Text(
                                  " ${widget.op.products.length}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text("Price:"),
                                Text(
                                  " ₹${widget.op.total}",
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 15),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.op.status == "placed"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2 - 15,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              child: const Text(
                                'NEED HELP ?',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2 - 15,
                            child: ElevatedButton(
                              onPressed: () {
                                showAlertDialog(context, widget.op);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text(
                            'NEED HELP ?',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                widget.op.status == "placed"
                    ? SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'CALL DELIVERY PERSON',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "PRODUCT DETAILS",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.op.products.length,
                            itemBuilder: (context, index) {
                              var x = widget.op.products[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      x.name,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    Text(
                                      x.size,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      "${x.qty}X",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      "₹${x.price}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const Divider(
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            const Text("TOTAL: "),
                            const Spacer(),
                            Text(
                              "₹ ${widget.op.total}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
