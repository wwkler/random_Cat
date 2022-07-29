import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:random_cat_practice/model/model.dart';
import 'package:random_cat_practice/stroage/stroage.dart';
import 'package:random_cat_practice/viewPhoto.dart';

// '좋아요' Icon만 누른 고양이만 보여주는 상태 관리 Widget
class LikeCats extends StatefulWidget {
  //중앙 집중식 관리 데이터에 전역적으로 접근할 수 있도록 장치를 마련한다.
  UseProvider provider;

  LikeCats({required this.provider, Key? key}) : super(key: key);

  @override
  State<LikeCats> createState() => _LikeCatsState();
}

class _LikeCatsState extends State<LikeCats> {
  // 중앙 집중식 관리 데이터 List<CatModel> cats 이다. (call by reference)
  List<CatModel> favoriteCats = [];

  @override
  Widget build(BuildContext context) {
    print('likeCats - build() 실행');

    return Consumer<UseProvider>(builder: (context, provider, child) {
      favoriteCats = provider.cats!;

      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            leading: Icon(
              Icons.pets,
              color: Colors.redAccent,
            ),
            title: Text(
              'Favorite Cats',
              style: GoogleFonts.bahiana(
                fontSize: 35.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.pets,
                  color: Colors.amber,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 20,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back)),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(favoriteCats.length, (index) {
                    CatModel cat = favoriteCats[index];
                    String catUrl = cat.url;
          
                    return GestureDetector(
                        onTap: () {
                           // PhtoView를 보여주기 위한 화면 전환 
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ViewPhoto(catUrl: catUrl);
                        }));
                        },
                        
                        onDoubleTap: () {
                          // 선택한 고양이 이미지 파일을 SharedPreferences 에서 삭제한다.
                          provider.deleteFavoriteCat(cat);
          
                          setState(() {
                            provider
                                .getFavoriteCats(); // 최신 상태의 SharedPreferences 파일을 가져온다.
                          });
                        },
                        child: Stack(
                          children: [
                            // Image
                            Positioned.fill(
                              child: Image.network(
                                catUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ));
                  }),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
