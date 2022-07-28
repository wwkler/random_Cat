import 'package:flutter/cupertino.dart';

class CatModel {
  // Field
  String url;
  bool isChecked;

  // Constructor
  CatModel({required this.url, required this.isChecked});


  

  // Method (위 3개 Method는 결국 SharedPreferences와 통신하기 위해 필요한 것들)

  // List<CatModel> -> Map -> List<JsonString> 으로 전환하기 위해 거치는 함수
  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "isChecked": isChecked,
    };
  }

  // List<JsonString> -> Map -> List<CatModel> 으로 전환하기 위해 거치는 함수
  factory CatModel.fromJson(Map<String, dynamic> jsonData) {
    return CatModel(
      url: jsonData["url"],
      isChecked: jsonData["isChecked"],
    );
  }

  // CatModel.fromJson Method는 Instance가 있어야 호출이 가능하기 떄문에 static Method를 이용해 연결
  static CatModel goFromJson(Map<String, dynamic> jsonData) {
    CatModel cat = CatModel.fromJson(jsonData);
    return cat;
  }
}
