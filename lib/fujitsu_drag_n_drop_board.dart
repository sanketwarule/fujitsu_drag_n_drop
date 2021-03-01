import 'dart:convert';

import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:fujitsu_drag_n_drop/items.dart';
import 'package:fujitsu_drag_n_drop/list_items.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FujitsuDragNDropBoard extends StatefulWidget {

  @override
  _FujitsuDragNDropBoardState createState() => _FujitsuDragNDropBoardState();
}

class _FujitsuDragNDropBoardState extends State<FujitsuDragNDropBoard> {
  List<BoardListItem> _listData = [];
  BoardViewController boardViewController = new BoardViewController();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getInitialList().then((value){
      setState(() {
        _listData = value;
      });
    });
    
  }
  
  Future<List<BoardListItem>>getInitialList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("list") != null && sharedPreferences.getString("list").isNotEmpty) {
      _listData = (json.decode(sharedPreferences.getString("list")) as List)
          .map((i) => BoardListItem.fromJson(i))
          .toList();
      print("listData : " + _listData.toString());
    }else {
      _listData = [
        BoardListItem(title: "Column 1", items: [BoardItems(title: 'ONE'), BoardItems(title:'TWO'),BoardItems(title:'THREE'),BoardItems(title:'FOUR'),]),
        BoardListItem(title: "Column 2",items: [BoardItems(title: 'MUMBAI'), BoardItems(title:'PUNE'),BoardItems(title:'CHENNAI'),BoardItems(title:'NAGPUR'),BoardItems(title:'BANGALORE'),]),
      ];
    }
    return _listData;
  }

  Future<bool> saveList(List<BoardListItem> outerList) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var list = json.encode(outerList.map((e) => e.toJson()).toList());
    bool hasSaved = await sharedPreferences.setString("list", list);
    print("saved");
    return hasSaved;
  }

  @override
  Widget build(BuildContext context) {
    List<BoardList> _lists = <BoardList>[];
    for (int i = 0; i < _listData?.length; i++) {
      _lists.add(_createBoardList(_listData[i]));
    }
    return Column(
      children: [
        Container(
          height: 500,
          child: BoardView(
            lists: _lists,
            boardViewController: boardViewController,
          ),
        ),

        RaisedButton(onPressed: () async{
          if(await saveList(_listData)){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved Successfully")));
            return;
          }else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved Successfully")));
          }
        },child: Text("Save"),)
      ],
    );
  }

  Widget buildBoardItem(BoardItems itemObject) {
    return BoardItem(
        onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {

        },
        onDropItem: (int listIndex, int itemIndex, int oldListIndex,
            int oldItemIndex, BoardItemState state) {
          //Used to update our local item data
          var item = _listData[oldListIndex].items[oldItemIndex];
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex].items.insert(itemIndex, item);
        },
        onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {

        },
        item: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(itemObject.title),
          ),
        ));
  }

  Widget _createBoardList(BoardListItem list) {
    List<BoardItem> items = new List();
    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]));
    }

    return BoardList(
      draggable: false,
      onStartDragList: (int listIndex) {

      },
      onTapList: (int listIndex) async {

      },
      onDropList: (int listIndex, int oldListIndex) {
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor: Color.fromARGB(255, 235, 236, 240),
      backgroundColor: Color.fromARGB(255, 235, 236, 240),
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 20),
                ))),
      ],
      items: items,
    );
  }
}

