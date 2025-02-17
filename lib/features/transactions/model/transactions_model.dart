import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class TransactionsModel extends SingleMapper {
  String? status;
  String? message;
  List<TransactionModel>? data;
  Meta? meta;

  TransactionsModel({
    this.status,
    this.message,
    this.data,
  });

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    data = json["data"] == null
        ? []
        : List<TransactionModel>.from(
            json["data"]!.map((x) => TransactionModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TransactionsModel.fromJson(json);
  }
}

class TransactionModel extends SingleMapper {
  int? id;
  TransactionRouteModel? route;
  String? transactionNum;
  String? createAt;
  String? createTime;
  String? title;
  double? amount;
  TransactionType? type;

  TransactionModel({
    this.id,
    this.transactionNum,
    this.route,
    this.amount,
    this.title,
    this.type,
    this.createAt,
    this.createTime,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionNum = json['transaction_num']?.toString();
    amount =
        json['amount'] != null ? double.parse(json['amount']!.toString()) : 0;
    title = json['title']?.toString();
    type = checkTransactionType(json['type']); // pay && deposit && withdraw
    route = json['route'] != null
        ? TransactionRouteModel.fromJson(json['route'])
        : null;
    createAt = json['create_at'];
    createTime = json['create_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_num'] = transactionNum;
    data['title'] = title;
    data['amount'] = amount;
    data['type'] = type;
    data['route'] = route?.toJson();
    data['create_at'] = createAt;
    data['create_time'] = createTime;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return TransactionModel.fromJson(json);
  }
}

class TransactionRouteModel {
  int? id;
  TransactionRouteType? type;

  TransactionRouteModel({
    this.id,
    this.type,
  });

  TransactionRouteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = checkTransactionRouteType(json['type']); // order && product
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

enum TransactionType { pay, deposit, withdraw }

enum TransactionRouteType { order, product }

checkTransactionType(type) {
  if (type == TransactionType.pay.name) {
    return TransactionType.pay;
  }
  if (type == TransactionType.deposit.name) {
    return TransactionType.deposit;
  }
  if (type == TransactionType.withdraw.name) {
    return TransactionType.withdraw;
  } else {
    return TransactionType.pay;
  }
}

checkTransactionRouteType(type) {
  if (type == TransactionRouteType.order.name) {
    return TransactionRouteType.order;
  }
  if (type == TransactionRouteType.product.name) {
    return TransactionRouteType.product;
  } else {
    return TransactionRouteType.order;
  }
}
