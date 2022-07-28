import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:random_cat_practice/model/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseProvider extends ChangeNotifier {
  SharedPreferences? pref;

  // List<CatModel> 형식 Model data
  // HomeScreen에서  GridView로 나타내기 위해 쓰이는 중앙 관리 데이터,
  // "좋아요" Page에서 GridView로 나타내기 위해 쓰이는 중앙 관리 데이터
  List<CatModel>? cats;

  // List<String> 형식 SharedPreferences data
  // SharedPreferences 파일에서 가져와 쓰이는 중앙 관리 데이터
  List<String> sharedPreferences_cats = [];

  // "좋아요" 페이지에서 고양이 삭제할 떄 저장하는 중앙 관리 데이터 
  List<String> delete_sharedPreferences_cats = [];

  // SharedPreferneces 파일 조회(Read)
  Future<void> getFavoriteCats() async {
    if (pref == null) {
      print('pref가 null이여서 instance를 구합니다.');
      pref = await SharedPreferences.getInstance();
    }

    // SharedPreferences 파일을 가져와
    // 중앙 집중 관리 데이터 List<String> sharedPreferences_cats에 값을 Update
    sharedPreferences_cats = pref!.getStringList('favorite_cat_list') ?? [];

    // List<String> -> Map -> List<CatModel> 형식으로 바꿔서
    // 중앙 집중식 관리 데이터 List<CatModel> cats에 값을 Update 한다.
    cats = [];

    for (int i = 0; i < sharedPreferences_cats.length; i++) {
      Map<String, dynamic> jsonDecodeCat =
          jsonDecode(sharedPreferences_cats[i]);

      CatModel cat = CatModel.goFromJson(jsonDecodeCat);

      cats!.add(cat);
    }
  }

  // SharedPreferences 파일 데이터 추가(Insert)
  Future<void> addFavoriteCat(CatModel cat) async {
    if (pref == null) {
      pref = await SharedPreferences.getInstance();
    }

    // DataModel -> Map -> JsonString 형식으로 바꾸는 작업
    String jsonCat = jsonEncode(cat.toJson());

    sharedPreferences_cats.add(jsonCat);

    pref!.setStringList('favorite_cat_list', sharedPreferences_cats);
  }

  // SharedPreferences 파일에 데이터를 삭제하는 Method (Delete)
  Future<void> deleteFavoriteCat(CatModel cat) async {
    if (pref == null) {
      pref = await SharedPreferences.getInstance();
    }

    print('삭제되기 전 : ${sharedPreferences_cats}');

    // "좋아요" page에서 삭제한 고양이 파일이 SharedPrefernces 파일에도 존재하는지 확인하는 Code
    for (int i = 0; i < sharedPreferences_cats.length; i++) {
      String url = jsonDecode(sharedPreferences_cats[i])['url'];

      // 선택한 이미지가 SharedPreferences 파일에 있으면
      // 삭제 파일을 관리하는 List<String> delete_sharedPreferences에 값을 Update
      // SharedPreferences 파일을 저장하는 List<String> shardPreferences_cats에 값을 Update
      if (url.compareTo(cat.url) == 0) {
        delete_sharedPreferences_cats.add(url);
        sharedPreferences_cats.removeAt(i);

        // for문 탈출 
        break; 
      }
    }

    print('삭제된 후 : ${sharedPreferences_cats}');

    pref!.setStringList('favorite_cat_list', sharedPreferences_cats);
  }
}
