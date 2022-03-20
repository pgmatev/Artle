import 'dart:convert';

List<History> historyFromJson(String str) => List<History>.from(json.decode(str).map((x) => History.fromJson(x)));

String historyToJson(List<History> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class History {
  History({
    this.createdAt,
    this.id,
    this.templateType,
  });

  String? createdAt;
  int? id;
  String? templateType;

  factory History.fromJson(Map<String, dynamic> json) => History(
    createdAt: json["created_at"],
    id: json["id"],
    templateType: json["template_type"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "id": id,
    "template_type": templateType,
  };
}