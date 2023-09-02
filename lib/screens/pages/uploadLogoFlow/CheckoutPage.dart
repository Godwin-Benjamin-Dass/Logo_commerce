import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/product.dart';
import 'package:logo_commerce/View_Model/Product_Provider.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage(
      {required this.products,
      required this.subtotal,
      required this.shipping,
      required this.total,
      required this.logoImage});
  final List<product> products;
  final double subtotal;
  final double shipping;
  final double total;
  final File logoImage;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  AddDataAlert(BuildContext context, ProductProvider pro) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        pro.products.clear();
        pro.ResetTotal();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("ALERT"),
      content: const Text("Your order is placed successfully"),
      actions: [
        cancelButton,
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

  @override
  Widget build(BuildContext context) {
    var _Products = Provider.of<ProductProvider>(context);
    placeOrder(List<Map<String, dynamic>> data, String img) {
      final _CollectionReference = FirebaseFirestore.instance
          .collection("Orders")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("orders")
          .doc();
      return _CollectionReference.set({
        "id": _CollectionReference.id,
        "products": data,
        "total": _Products.total.toString(),
        "imgUrl": img,
        "Time": DateTime.now(),
        "status": "placed",
        "UserId": FirebaseAuth.instance.currentUser!.email,
      }).then((value) {
        AddDataAlert(context, _Products);
      });
    }

    List<Map<String, dynamic>> pro() {
      List<Map<String, dynamic>> datalist = [];
      for (int i = 0; i < _Products.products.length; i++) {
        datalist.add({
          "name": _Products.products[i].name,
          "price": _Products.products[i].price,
          "qty": _Products.products[i].qty,
          "size": _Products.products[i].size
        });
      }
      return datalist;
    }

    String imageToBase64(File imageFile) {
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      return base64Image;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Checkout'),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pinkAccent, Colors.red],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        const SizedBox(
                          height: 15,
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _Products.products.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      _Products.products[index].name,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _Products.products[index].size,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.red,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      _Products.products[index].qty,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      "₹ ${_Products.products[index].price}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _Products.RemoveProduct(
                                            _Products.products[index].id,
                                            (double.parse(_Products
                                                    .products[index].price) *
                                                int.parse(_Products
                                                    .products[index].qty)));
                                        if (_Products.products.isEmpty) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      icon: Icon(Icons.close),
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              );
                            }),
                        const Divider(
                          color: Colors.black,
                        ),
                        Row(
                          children: [
                            Text("TOTAL: "),
                            Spacer(),
                            Text(
                              "₹ ${_Products.total}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      placeOrder(pro(), imageToBase64(widget.logoImage));
                    },
                    child: Text(
                      'PLACE ORDER',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),

                    // pro(), widget.total, imageToBase64(widget.logoImage)
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
