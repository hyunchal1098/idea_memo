import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:idea_memo/data/idea_info.dart';
import 'package:idea_memo/database/database_helper.dart';

class DetailScreen extends StatelessWidget {
  IdeaInfo ideaInfo;

  final dbHelper = DatabaseHelper();

  DetailScreen({super.key, required this.ideaInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        ///!를 붙여주는 이유는 절대 null이 될 수 없음을 전달
        title: Text(
          ideaInfo!.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 삭제
              // 1. 삭제여부를 묻는 모달창
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("주의"),
                    content: Text("데이터를 삭제하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ///다이얼로그 팝업종료(일반 화면 pop과는 달리 of를 붙힘)
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "취소",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 삭제 프로세스
                          // 1. 데이터 삭제처리
                          await setDeleteIdeaInfo(ideaInfo.id!);
                          // 2. 팝업 종료 > 화면 종료(
                          ///mounted가 true이어야 위젯을 제어할 수 있는 BuildContext 클래스에 접근가능함
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.pop(context, "delete");
                          }
                        },
                        child: Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              );
            },
            child: Text(
              "삭제",
              style: TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Expanded는 flex default가 1이므로 하나의 위젯에 적용하면 그 위젯이 전체를 너비를 다 먹으려고 하기 때문에
          /// 차지할수 있는 모든 영역을 차지하고 나머지 위젯들은 최소한의 너비만 보이게 됨ㅁ
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 계기
                    Text(
                      "아이디어를 떠올린 게기",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo.motive,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // 내용
                    Text(
                      "아이디어 내용",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // 중요도 점수
                    Text(
                      "아이디어 중요도 점수",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: ideaInfo.priority.toDouble(),
                      ignoreGestures: true,
                      updateOnDrag: false,
                      allowHalfRating: true,
                      itemSize: 35,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (value) {},
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // 피드백
                    Text(
                      "유저 피드백 사항",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo.feedback ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              height: 65,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("내용 편집하기"),
            ),
            onTap: () async {
              // edit screen 이동
              var result =
                  await Navigator.pushNamed(context, "/edit", arguments: ideaInfo);

              if (result != null) {
                if (context.mounted) {
                  Navigator.pop(context, "update");
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future setDeleteIdeaInfo(int id) async {
    //기존 아이디어 제거
    await dbHelper.initDatabase();
    await dbHelper.deleteIdeaInfo(id);
  }
}
