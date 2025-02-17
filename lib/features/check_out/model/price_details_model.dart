import '../../../app/localization/language_constant.dart';
import '../../../data/config/mapper.dart';

class PriceDetailsModel extends SingleMapper {
  double? staffCost;
  double? subTotal;
  double? servicePercentage;
  double? service;
  double? tax;
  double? taxPercentage;
  double? fees;
  double? feesPercentage;
  double? couponPrice;
  double? couponPercentage;
  double? totalPrice;
  String? currency;

  PriceDetailsModel(
      {this.staffCost,
      this.subTotal,
      this.taxPercentage,
      this.tax,
      this.service,
      this.servicePercentage,
      this.fees,
      this.feesPercentage,
      this.couponPrice,
      this.couponPercentage,
      this.totalPrice,
      this.currency});

  PriceDetailsModel.fromJson(Map<String, dynamic> json) {
    staffCost = json['staff_cost'] != null
        ? double.parse(json['staff_cost'].toString())
        : null;
    subTotal = json['sub_total'] != null
        ? double.parse(json['sub_total'].toString())
        : null;

    servicePercentage = json['service_percentage'] != null
        ? double.parse(json['service_percentage'].toString())
        : null;
    service = json['service_value'] != null
        ? double.parse(json['service_value'].toString())
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staff_cost'] = staffCost;
    data['sub_total'] = subTotal;
    data['service_percentage'] = servicePercentage;
    data['service_value'] = service;
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
    return PriceDetailsModel.fromJson(json);
  }
}
