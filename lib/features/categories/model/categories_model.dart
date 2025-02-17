import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class CategoriesModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<CategoryModel>? data;
  Meta? meta;

  CategoriesModel({
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

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta =
        json['pagination'] != null ? Meta.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CategoriesModel.fromJson(json);
  }
}

class CategoryModel extends SingleMapper {
  int? id;
  String? name;
  String? description;
  String? image;
  bool? is24Hr;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.is24Hr,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["desc"];
    image = json["image"];
    is24Hr = json["is_available_all_time"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": description,
        "image": image,
        "is_available_all_time": is24Hr,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CategoryModel.fromJson(json);
  }
}
