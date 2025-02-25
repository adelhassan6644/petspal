import '../../../data/config/mapper.dart';

class ProductDetailsModel extends SingleMapper {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  double? priceAfter;
  double? discount;
  int? quantity;

  ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.priceAfter,
    this.discount,
    this.quantity,
  });

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["desc"];
    price =
        json["price"] != null ? double.parse(json["price"].toString()) : null;
    priceAfter = json["price_after"] != null
        ? double.parse(json["price_after"].toString())
        : null;
    image = json["image"];
    discount = json["discount"];
    quantity = json["quantity"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": description,
        "image": image,
        "price": price,
        "price_after": priceAfter,
        "discount": discount,
        "quantity": quantity,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel.fromJson(json);
  }
}
