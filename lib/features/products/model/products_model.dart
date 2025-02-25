import 'package:petspal/features/categories/model/categories_model.dart';

import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class ProductsModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<ProductModel>? data;

  Meta? meta;

  ProductsModel({
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  @override
  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "pagination": meta?.toJson(),
        "data": data != null
            ? List<ProductModel>.from(data!.map((x) => x.toJson()))
            : [],
      };

  ProductsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta =
        json['pagination'] != null ? Meta.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(ProductModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProductsModel.fromJson(json);
  }
}

class ProductModel extends SingleMapper {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  double? priceAfter;
  double? discount;
  int? quantity;
  double? avgRate;
  CategoryModel? category;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.priceAfter,
    this.discount,
    this.quantity,
    this.category,
    this.avgRate,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["desc"];
    category = json["category"] != null
        ? CategoryModel.fromJson(json["category"])
        : null;
    price =
        json["price"] != null ? double.parse(json["price"].toString()) : null;
    priceAfter = json["price_after"] != null
        ? double.parse(json["price_after"].toString())
        : null;
    image = json["image"];
    avgRate = json["avg_rate"];
    discount = json["discount"];
    quantity = json["quantity"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "desc": description,
        "category": category?.toJson(),
        "price": price,
        "price_after": priceAfter,
        "discount": discount,
        "avg_rate": avgRate,
        "quantity": quantity,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProductModel.fromJson(json);
  }
}
