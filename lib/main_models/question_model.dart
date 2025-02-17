import '../data/config/mapper.dart';

class QuestionModel extends SingleMapper {
  int? id;
  String? question;
  String? answer;

  QuestionModel({
    this.id,
    this.question,
    this.answer,
  });

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    question = json["question"];
    answer = json["answer"];
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return QuestionModel.fromJson(json);
  }
}
