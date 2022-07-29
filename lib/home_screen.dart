import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:random_cat_practice/api/getCatsUrl.dart';
import 'package:random_cat_practice/likeCats.dart';
import 'package:random_cat_practice/model/model.dart';
import 'package:random_cat_practice/stroage/stroage.dart';
import 'package:random_cat_practice/viewPhoto.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 중앙 관리 데이터 List<CatModel> cats에 값을 넣기 위한 교두보 역할
  List<CatModel> cats = [];
  // Method
  @override
  void initState() {
    super.initState();

    print('initState()이 호출되었습니다.');

    useApi(); // async 함수
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen - build()가 호출되었습니다.');
    return Consumer<UseProvider>(builder: (context, provider, child) {
      // Random Cat API를 호출하여, DataModel로 변형한 자료를
      // 중앙 관리 데이터 List<CatModel> cats에 값을 넣는다.
      provider.cats = cats;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: myAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 새로 고침 Icon, 다음으로 가기 Icon이 있는 Widget
              TopWidget(
                refreshAPI: refreshAPI,
                getFavoriteCats: getFavoriteCats,
              ),
              Divider(
                height: 2.0,
                color: Colors.red,
              ),
              // GridView를 관리하는 Widget
              MiddleWidget(
                provider: provider,
              ),
            ],
          ),
        ),
      );
    });
  }

  // 내가 설정한 AppBar 입니다.
  AppBar myAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.0,
      centerTitle: true,
      leading: Icon(
        Icons.pets,
        color: Colors.redAccent,
      ),
      title: Text(
        'Random Cat',
        style: GoogleFonts.bahiana(
          fontSize: 35.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            Icons.pets,
            color: Colors.amber,
          ),
        )
      ],
    );
  }

  // Random Cat API를 불러오는 Method
  Future<void> useApi() async {
    // API Response Data를 DataModel 형식으로 전환하여
    // 중앙 집중 관리 데이터 List<CatModel> cats에 값을 Update 한다.
    cats = await UseCatsAPI.getInstance()!.getCatsData(cats);

    // HomeScreen - build()와 연결하여, 화면을 다시 그릴 수 있도록 한다.
    setState(() {});
  }

  // 'Refesh Icon' Click하면  다시 API를 Response Data를 가져오는 Method
  void refreshAPI() {
    useApi();
  }

  // 'Right Arrow Icon' Click하면 SharedPrefences 파일을 가져와
  // 중앙 집중 관리 데이터 List<CatModel> cats에 값을 Update 하는 Method
  Future<void> getFavoriteCats() async {
    UseProvider provider = context.read<UseProvider>();

    // 요 부분이 SharedPrefernces 파일을 가져와
    // 중앙 집중 관리 데이터 List<CatModel> cats에 값을 Update하는 Code다.
    await provider.getFavoriteCats();

    // "좋아요" Page로 화면 전환
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return LikeCats(provider: provider);
    }));

    // provier delete_sharedPreferences와 cats 비교
    // 일치하면 좋아요 색을 "하얀색"으로 그렇지 않으면 좋아요 색은 "노란색"으로 업데이트
    for (int i = 0; i < provider.delete_sharedPreferences_cats.length; i++) {
      for (int j = 0; j < cats.length; j++) {
        if (provider.delete_sharedPreferences_cats[i].compareTo(cats[j].url) ==
            0) {
          cats[j].isChecked = false;
          break; // 안쪽 for문 탈출
        }
      }
    }

    provider.delete_sharedPreferences_cats = [];

    setState(() {});
  }
}

// GridView를 보여주는 상태 관리 Widget
class MiddleWidget extends StatefulWidget {
  final UseProvider provider;

  const MiddleWidget({
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  State<MiddleWidget> createState() => _MiddleWidgetState();
}

class _MiddleWidgetState extends State<MiddleWidget> {
  @override
  Widget build(BuildContext context) {
    print('MiddleWidget - build()가 호출되었습니다.');

    print('중앙 집중식 관리 데이터 cat : ${widget.provider.cats}');

    return widget.provider.cats!.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(child: CircularProgressIndicator()),
          )
        : Container(
            margin: EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3 / 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(widget.provider.cats!.length, (index) {
                CatModel cat = widget.provider.cats![index];
                String catUrl = cat.url;

                print('고양이 ${index} 번쨰가 호출되었습니다.');

                return GestureDetector(
                    onTap: () {
                      print('onTap 했습니다.');

                      // PhtoView를 보여주기 위한 화면 전환 
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ViewPhoto(catUrl: catUrl);
                      }));
                    },
                    child: Stack(
                      children: [
                        // Cat Image
                        Positioned.fill(
                          child: Image.network(
                            catUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // "좋아요" Image Button
                        Positioned(
                            bottom: 3,
                            right: 3,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    cat.isChecked = !cat.isChecked;

                                    // 좋아요 색깔 "하얀색" -> "노란색"
                                    if (cat.isChecked) {
                                      // SharedPreferences 파일에 data를 추가한다.
                                      widget.provider
                                          .addFavoriteCat(cat); // async 함수
                                    } else {
                                      // SharedPreferences 파일에 data를 삭제한다.
                                      widget.provider.deleteFavoriteCat(cat);
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: cat.isChecked
                                      ? Colors.yellow
                                      : Colors.white,
                                ))),
                      ],
                    ));
              }),
            ),
          );
  }
}

// TopWidget을 상태 관리하는 Widget
class TopWidget extends StatelessWidget {
  final VoidCallback refreshAPI;
  final VoidCallback getFavoriteCats;

  const TopWidget({
    required this.refreshAPI,
    required this.getFavoriteCats,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          IconButton(
            onPressed: refreshAPI,
            icon: Icon(Icons.autorenew_sharp),
          ),
          IconButton(
            onPressed: getFavoriteCats,
            icon: Icon(Icons.arrow_forward),
          )
        ]),
      ),
    );
  }
}
