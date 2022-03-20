import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
  Task({
    this.model,
    this.suggestion,
    this.thought,
    this.url,
  });

  String? model;
  String? suggestion;
  String? thought;
  String? url;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    model: json["model"],
    suggestion: json["suggestion"],
    thought: json["thought"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "suggestion": suggestion,
    "thought": thought,
    "url": url,
  };
}
