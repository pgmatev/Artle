import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    this.model,
    this.suggestion,
    this.thought,
    this.url,
    this.title,
    this.image
  });

  String? model;
  String? suggestion;
  String? thought;
  String? url;
  String? title;
  String? image;
  bool isLiked = false;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    model: json["model"],
    suggestion: json["suggestion"],
    thought: json["thought"],
    url: json["url"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "suggestion": suggestion,
    "thought": thought,
    "url": url,
    "is_liked": isLiked,
    "title": title,
    "image": image,
  };
}
