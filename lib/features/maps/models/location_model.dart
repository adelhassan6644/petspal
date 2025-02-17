import 'package:zurex/data/config/mapper.dart';

class LocationModel extends SingleMapper {
  double? latitude;
  double? longitude;
  String? address;

  Function(LocationModel)? onChange;

  LocationModel({
    this.address,
    this.latitude,
    this.longitude,
    this.onChange,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    latitude = json['lat'];
    longitude = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['lat'] = latitude;
    data['long'] = longitude;

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return LocationModel.fromJson(json);
  }
}
