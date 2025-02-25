import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class VendorsModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<VendorModel>? data;
  Meta? meta;

  VendorsModel({
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
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };

  VendorsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta =
        json['pagination'] != null ? Meta.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(VendorModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return VendorsModel.fromJson(json);
  }
}

class VendorModel extends SingleMapper {
  int? id;
  String? name;
  String? description;
  String? image;
  double? avgRate;

  VendorModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.avgRate,
  });

  VendorModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["desc"];
    image = json["image"];
    avgRate = json["avg_rate"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": description,
        "image": image,
        "avg_rate": avgRate,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return VendorModel.fromJson(json);
  }
}
