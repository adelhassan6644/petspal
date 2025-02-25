import '../../../app/localization/language_constant.dart';
import '../../../data/config/mapper.dart';

class ReceiptDetailsModel extends SingleMapper {
  double? subTotal;
  double? tax;
  double? taxPercentage;
  double? fees;
  double? feesPercentage;
  double? couponPrice;
  double? couponPercentage;
  double? totalPrice;
  String? currency;

  ReceiptDetailsModel(
      {this.subTotal,
      this.taxPercentage,
      this.tax,
      this.fees,
      this.feesPercentage,
      this.couponPrice,
      this.couponPercentage,
      this.totalPrice,
      this.currency});

  ReceiptDetailsModel.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'] != null
        ? double.parse(json['sub_total'].toString())
        : null;
    taxPercentage = json['tax_percentage'] != null
        ? double.parse(json['tax_percentage'].toString())
        : null;
    tax = json['tax_value'] != null
        ? double.parse(json['tax_value'].toString())
        : null;
    feesPercentage = json['fees_percentage'] != null
        ? double.parse(json['fees_percentage'].toString())
        : null;
    fees = json['fees_value'] != null
        ? double.parse(json['fees_value'].toString())
        : null;
    couponPercentage = json['couponPercentage'] != null
        ? double.parse(json['couponPercentage'].toString())
        : null;
    couponPrice = json['couponPrice'] != null
        ? double.parse(json['couponPrice'].toString())
        : json['coupon_price'] != null
            ? double.parse(json['coupon_price'].toString())
            : null;

    totalPrice = json['total_price'] != null
        ? double.parse(json['total_price'].toString())
        : null;

    currency = json['currency'] ?? getTranslated("sar");
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub_total'] = subTotal;
    data['tax_percentage'] = taxPercentage;
    data['tax_value'] = tax;
    data['fees_percentage'] = feesPercentage;
    data['fees_value'] = fees;
    data['couponPercentage'] = couponPercentage;
    data['couponPrice'] = couponPrice;
    data['total_price'] = totalPrice;
    data['currency'] = currency;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ReceiptDetailsModel.fromJson(json);
  }
}
