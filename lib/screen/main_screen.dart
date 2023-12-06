import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:idea_memo/database/database_helper.dart';
import 'package:intl/intl.dart';

import '../data/idea_info.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    getCreateInfo();
    //setDeleteIdeaInfo();

    //setInsertIdeaInfo();
  }

  var dbHelper = DatabaseHelper();
  List<IdeaInfo> listIdeaInfo = [];

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Archive Idea",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            return Container(
              margin: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: listIdeaInfo.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: listItem(index),
                    onTap: () async {
                      String msg = "";

                      var result = await Navigator.pushNamed(
                        context,
                        "/detail",
                        arguments: listIdeaInfo[index],
                      );

                      //a > b > a b화면에서 데이터를 넘겨 받았을 때
                      if (result != null) {
                        //수정완료
                        if (result == "update") {
                          msg = "수정이 완료되었습니다.";
                        } else if (result == "delete") {
                          msg = "삭제가 완료되었습니다.";
                        }
                        //삭제완료
                        // 데이터 재조회
                        getCreateInfo();
                        // snapbar

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(msg),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            );
          }
        ),

        //하단 플로팅 버튼
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                //새 아이디어 작성 페이지 이동(비동기방식처리)
                var result = await Navigator.pushNamed(context, "/edit");

                //a > b > a b화면에서 데이터를 넘겨 받았을 때
                if (result != null) {
                  // 데이터 재조회
                  getCreateInfo();
                  // snapbar

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("새로운 아이디어가 추가되었습니다."),
                      ),
                    );
                  }
                }
              },
              backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                "assets/idea.png",
                width: 45,
                height: 45,
              ),
            );
          }
        ),
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: 82,

      ///ShapeDecoration : 모양 deco
      decoration: ShapeDecoration(
        ///둥글게 처리
        shape: RoundedRectangleBorder(
          ///윤곽선 속성
          side: BorderSide(
            color: Color(0xffd9d9d9),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 16,
              bottom: 16,
            ),
            child: Text(
              listIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),

          ///Align : 강제적으로 위치지정
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(
                right: 16,
                bottom: 10,
              ),
              child: Text(
                DateFormat("yyyy.MM.dd HH:mm").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      listIdeaInfo[index].updatedDt),
                ),
                style: const TextStyle(
                  color: Color(0xffaeaeae),
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: 16,
                bottom: 8,
              ),
              child: RatingBar.builder(
                initialRating: listIdeaInfo[index].priority,
                minRating: 1,
                direction: Axis.horizontal,
                itemSize: 16,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                ignoreGestures: true,
                updateOnDrag: false,
                onRatingUpdate: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getCreateInfo() async {
    await dbHelper.initDatabase();
    //idea 데이터를 전역 변수 객체에 담기
    listIdeaInfo = await dbHelper.getAllIdeaInfo();
    listIdeaInfo.sort(
      //a가 이전 데이터, b가 이후 데이터 비교하여 순방향 정렬
      (a, b) => b.updatedDt.compareTo(a.updatedDt),
    );
    //데이터 변동이 있던 없던 빌드
    setState(() {});
  }

  Future setInsertIdeaInfo() async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(
      IdeaInfo(
        title: "example title",
        motive: "example motive",
        content: "example content",
        priority: 4.5,
        feedback: "example feedback",
        createdDt: DateTime.now().millisecondsSinceEpoch,
        updatedDt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future setDeleteIdeaInfo() async {
    await dbHelper.initDatabase();
    await dbHelper.deleteIdeaInfo(1);
  }
}
