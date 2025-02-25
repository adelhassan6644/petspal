import 'package:petspal/features/cart/model/receipt_details_model.dart';

import '../../../data/config/mapper.dart';
import '../../products/model/products_model.dart';

class CartModel extends SingleMapper {
  ReceiptDetailsModel? receiptDetails;
  List<CartItemModel>? items;

  CartModel({
    this.receiptDetails,
    this.items,
  });

  @override
  Map<String, dynamic> toJson() => {
        "receipt_details": receiptDetails?.toJson(),
        "items": items != null
            ? List<dynamic>.from(items!.map((x) => x.toJson()))
            : [],
      };

  CartModel.fromJson(Map<String, dynamic> json) {
    receiptDetails = json['receipt_details'] != null
        ? ReceiptDetailsModel.fromJson(json['receipt_details'])
        : null;

    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(CartItemModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CartModel.fromJson(json);
  }
}

class CartItemModel extends SingleMapper {
  int? id;
  int? quantity;
  ProductModel? product;

  CartItemModel({this.id, this.quantity, this.product});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CartItemModel.fromJson(json);
  }
}
