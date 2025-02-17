
import '../../../data/config/mapper.dart';
import '../../check_out/model/price_details_model.dart';
import '../../products/model/products_model.dart';

class ProductDetailsModel extends SingleMapper {
  ProductModel? product;
  PriceDetailsModel? priceDetails;

  ProductDetailsModel({
    this.product,
    this.priceDetails,
  });

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    priceDetails = json['price_details'] != null
        ? PriceDetailsModel.fromJson(json['price_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product?.toJson();
    }
    if (priceDetails != null) {
      data['price_details'] = priceDetails?.toJson();
    }

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel.fromJson(json);
  }
}
