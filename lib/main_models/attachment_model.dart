class AttachmentModel {
  int? id;
  String? image;

  AttachmentModel({
    this.id,
    this.image,
  });

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}
