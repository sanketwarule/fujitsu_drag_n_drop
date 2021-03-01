class BoardItems {
  String title;

  BoardItems({
      this.title});

  BoardItems.fromJson(dynamic json) {
    title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    return map;
  }

}