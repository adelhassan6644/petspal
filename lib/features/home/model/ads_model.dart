import 'package:zurex/data/config/mapper.dart';


class AdsModel extends SingleMapper {
  String? message;
  List<AdsItem>? data;

  AdsModel({this.message, this.data});

  AdsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <AdsItem>[];
      json['data'].forEach((v) {
        data!.add(AdsItem.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return AdsModel.fromJson(json);
  }
}

class AdsItem {
  int? id;
  String? image;
  String? name;
  String? link;

  AdsItem({this.id, this.image, this.link, this.name});

  AdsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['link'] = link;
    return data;
  }
}
