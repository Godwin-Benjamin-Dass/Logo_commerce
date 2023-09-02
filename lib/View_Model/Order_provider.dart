import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/orderModel.dart';
import 'package:logo_commerce/Model/product.dart';

class OrderProvider extends ChangeNotifier {
  final CollectionReference _ordersCollection = FirebaseFirestore.instance
      .collection('Orders')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("orders");

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  List<OrderModel> _placed = [];
  List<OrderModel> get placed => _placed;
  List<OrderModel> _delivered = [];
  List<OrderModel> get delivered => _delivered;
  List<OrderModel> _canceled = [];
  List<OrderModel> get canceled => _canceled;

  fetchOrders() async {
    final querySnapshot = await _ordersCollection.get();
    final List<OrderModel> orders = [];

    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final List<product> products = [];
      for (int i = 0; i < data["products"].length; i++) {
        products.add(product(
          id: "",
          name: data["products"][i]["name"],
          price: data["products"][i]["price"],
          qty: data["products"][i]["qty"],
          size: data["products"][i]["size"],
        ));
      }

      final order = OrderModel(
        id: data['id'],
        userId: data['UserId'],
        imgUrl: data['imgUrl'],
        status: data['status'],
        total: data['total'],
        products: products,
      );

      orders.add(order);
    }

    _orders = orders;
    placed.clear();
    delivered.clear();
    canceled.clear();

    for (int i = 0; i < orders.length; i++) {
      if (orders[i].status == "placed") {
        placed.add(orders[i]);
      } else if (orders[i].status == "canceled") {
        canceled.add(orders[i]);
      } else {
        delivered.add(orders[i]);
      }
    }
    print("object");
    notifyListeners();
  }

  cancelOrder(OrderModel data) {
    canceled.add(OrderModel(
        id: data.id,
        userId: data.userId,
        imgUrl: data.imgUrl,
        status: "canceled",
        total: data.total,
        products: data.products));
    placed.removeWhere((element) => element.id == data.id);
    notifyListeners();
  }
}
