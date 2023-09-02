import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logo_commerce/View_Model/Order_provider.dart';
import 'package:logo_commerce/screens/pages/OrderFlow/MyOrderDetails.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    fetchAndSetData();
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  fetchAndSetData() async {
    await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Text('Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: "PLACED",
              ),
              Tab(
                text: "DELIVERED",
              ),
              Tab(
                text: "CANCELED",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            PlacedOrders(),
            DeliveredOrders(),
            CanceledOrders(),
          ],
        ),
      ),
    );
  }
}

class PlacedOrders extends StatelessWidget {
  const PlacedOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);
    Image imageFromBase64String(String base64String) {
      final decodedBytes = base64Decode(base64String);
      final image = Image.memory(decodedBytes);
      return image;
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pinkAccent, Colors.red],
        ),
      ),
      child: orderProvider.placed.isEmpty
          ? const Center(
              child: Text(
                "No Orders Placed Yet",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )
          : ListView.builder(
              itemCount: orderProvider.placed.length,
              itemBuilder: (ctx, i) {
                var order = orderProvider.placed[i];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderDetails(
                                    op: order,
                                  )));
                    },
                    child: Container(
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
                                  child: imageFromBase64String(order.imgUrl),
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
                                  "Order Status: ${order.status}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Items:"),
                                    Text(
                                      " ${order.products.length}",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("Price:"),
                                    Text(
                                      " ₹${order.total}",
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
                  ),
                );
              }),
    );
  }
}

class DeliveredOrders extends StatelessWidget {
  const DeliveredOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);

    Image imageFromBase64String(String base64String) {
      final decodedBytes = base64Decode(base64String);
      final image = Image.memory(decodedBytes);
      return image;
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pinkAccent, Colors.red],
        ),
      ),
      child: orderProvider.delivered.isEmpty
          ? const Center(
              child: Text(
                "No Orders Delivered Yet",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )
          : ListView.builder(
              itemCount: orderProvider.delivered.length,
              itemBuilder: (ctx, i) {
                var order = orderProvider.delivered[i];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
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
                                  child: imageFromBase64String(order.imgUrl),
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
                                  "Order Status: ${order.status}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Items:"),
                                    Text(
                                      " ${order.products.length}",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("Price:"),
                                    Text(
                                      " ₹${order.total}",
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
                  ),
                );
              }),
    );
  }
}

class CanceledOrders extends StatelessWidget {
  const CanceledOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var orderProvider = Provider.of<OrderProvider>(context);

    Image imageFromBase64String(String base64String) {
      final decodedBytes = base64Decode(base64String);
      final image = Image.memory(decodedBytes);
      return image;
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pinkAccent, Colors.red],
        ),
      ),
      child: orderProvider.canceled.isEmpty
          ? const Center(
              child: Text(
                "No Orders Canceled Yet",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            )
          : ListView.builder(
              itemCount: orderProvider.canceled.length,
              itemBuilder: (ctx, i) {
                var order = orderProvider.canceled[i];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderDetails(
                                    op: order,
                                  )));
                    },
                    child: Container(
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
                                  child: imageFromBase64String(order.imgUrl),
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
                                  "Order Status: ${order.status}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Items:"),
                                    Text(
                                      " ${order.products.length}",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text("Price:"),
                                    Text(
                                      " ₹${order.total}",
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
                  ),
                );
              }),
    );
  }
}
