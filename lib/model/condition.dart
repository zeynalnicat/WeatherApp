class Condition {
  String text;
  String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(text:json["text"] as String, icon:  "https:${json['icon']}" as String);
  }
}
