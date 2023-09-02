import 'package:logo_commerce/Model/product.dart';

class OrderModel {
  final String id;
  final String userId;
  final String imgUrl;
  final String status;
  final String total;
  final List<product> products;

  OrderModel({
    required this.id,
    required this.userId,
    required this.imgUrl,
    required this.status,
    required this.total,
    required this.products,
  });
}
