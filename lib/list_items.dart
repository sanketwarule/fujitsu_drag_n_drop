import 'items.dart';

class BoardListItem {
  String title;
  List<BoardItems> items;

  BoardListItem({
      this.title, 
      this.items});

  BoardListItem.fromJson(dynamic json) {
    title = json["title"];
    if (json["items"] != null) {
      items = [];
      json["items"].forEach((v) {
        items.add(BoardItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    if (items != null) {
      map["items"] = items.map((v) => v.toJson()).toList();
    }
    return map;
  }

}