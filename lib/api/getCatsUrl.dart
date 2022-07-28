import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_cat_practice/model/model.dart';
import 'package:random_cat_practice/stroage/stroage.dart';

// SingleTon 패턴으로 작성
// -> 여러번 코드가 불려도, 객체가 한번만 생성되도록 한다.
// -> 메모리 절약 효과
class UseCatsAPI {
  // Private Field
  static UseCatsAPI? _instance = null;
  Dio? _dio;

  // Private Constructor
  // 아 변수나 함수에 private 쓸 떄 _ 까지 이해하겠는데 ... Private Constructor 생성할 떄 괴상하네
  UseCatsAPI._() {
    _dio = Dio();
  }

  // method

  // 1. 객체를 만드는 부분
  static UseCatsAPI? getInstance() {
    if (_instance == null) {
      print('인스턴스를 만듭니다.');
      _instance = UseCatsAPI._();
    }
    return _instance;
  }

  // 2. 고양이 API를 이용해 새롭게 데이터를 불러오는 부분
  Future<List<CatModel>> getCatsData(List<CatModel> cats) async {
    cats = [];

    var apiDatas = await _dio!.get(
        "https://api.thecatapi.com/v1/images/search?limit=8&mine_types=jpg");

    print('API를 통해서 받아온 원본의 데이터 : ${apiDatas.data}');

    // api를 통해 받은 데이터를 기반으로 List<CatModel> cats에 할당하는 작업
    for (int i = 0; i < apiDatas.data.length; i++) {
      String url = apiDatas.data[i]['url']; //  api 데이터에서 'url' Property만 접근한다.
      cats.add(CatModel(url: url, isChecked: false));
    }

    print('API 데이터에서 알맞게 변형한 dataModel : ${cats}');

    return cats;
  }
}
