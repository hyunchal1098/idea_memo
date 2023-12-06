import 'package:flutter/material.dart';
import 'package:idea_memo/database/database_helper.dart';

import '../data/idea_info.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  //require를 하지않음
  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _motiveEditingController =
      TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();
  final TextEditingController _feedbackEditingController =
      TextEditingController();

  //점수 클릭에 따라 데코를 주기위한 클릭여부
  bool isClickPoint1 = false;
  bool isClickPoint2 = false;
  bool isClickPoint3 = true;
  bool isClickPoint4 = false;
  bool isClickPoint5 = false;

  double _priorityPoint = 3.0;

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //ideaInfo가 null이 아닌경우에만 처리
    if (widget.ideaInfo != null) {
      _titleEditingController.text = widget.ideaInfo!.title;
      _motiveEditingController.text = widget.ideaInfo!.motive;
      _contentEditingController.text = widget.ideaInfo!.content;
      _feedbackEditingController.text = widget.ideaInfo!.feedback ?? "";

      _priorityPoint = widget.ideaInfo!.priority;

      //선택여부 모두 false로 바꿈
      initClickState();

      switch (widget.ideaInfo!.priority) {
        case 1.0:
          isClickPoint1 = true;
        case 2.0:
          isClickPoint2 = true;
        case 3.0:
          isClickPoint3 = true;
        case 4.0:
          isClickPoint4 = true;
        case 5.0:
          isClickPoint5 = true;
      }
    }
  }

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
        //
        title: Text(widget.ideaInfo == null ? "새 아이디어 작성하기" : "아이디어 편집하기"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("제목"),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  //
                  textInputAction: TextInputAction.next,
                  // 텍스트 필드 데코
                  decoration: InputDecoration(
                    // 내부 입력값 패딩
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "아이디어 제목을 입력하세요.",
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  controller: _titleEditingController,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("아이디어 떠올린 계기"),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 41,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  // 텍스트 필드 데코
                  decoration: InputDecoration(
                    // 내부 입력값 패딩
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "계기를 입력하세요.",
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  controller: _motiveEditingController,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("아이디어내용"),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLength: 500,
                  maxLines: 5,
                  // 텍스트 필드 데코
                  decoration: InputDecoration(
                    // 내부 입력값 패딩
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "떠오른 아이디어 내용을 입력하세요.",
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  controller: _contentEditingController,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("아이디어 중요도 점수"),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint1 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            ///BorderSide : border 윤곽선 너비, 윤곽선 색깔
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼값 초기화
                        initClickState();
                        // 2. 선택된 버튼에 대한 변수값 및 위젯 update
                        setState(() {
                          isClickPoint1 = true;
                          _priorityPoint = 1;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint2 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            ///BorderSide : border 윤곽선 너비, 윤곽선 색깔
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "2",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼값 초기화
                        initClickState();
                        // 2. 선택된 버튼에 대한 변수값 및 위젯 update
                        setState(() {
                          isClickPoint2 = true;
                          _priorityPoint = 2;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint3 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            ///BorderSide : border 윤곽선 너비, 윤곽선 색깔
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "3",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼값 초기화
                        initClickState();
                        // 2. 선택된 버튼에 대한 변수값 및 위젯 update
                        setState(() {
                          isClickPoint3 = true;
                          _priorityPoint = 3;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint4 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            ///BorderSide : border 윤곽선 너비, 윤곽선 색깔
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "4",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼값 초기화
                        initClickState();
                        // 2. 선택된 버튼에 대한 변수값 및 위젯 update
                        setState(() {
                          isClickPoint4 = true;
                          _priorityPoint = 4;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 40,
                        decoration: ShapeDecoration(
                          color:
                              isClickPoint5 ? Color(0xffd6d6d6) : Colors.white,
                          shape: RoundedRectangleBorder(
                            ///BorderSide : border 윤곽선 너비, 윤곽선 색깔
                            side: BorderSide(
                              width: 1.5,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "5",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // 1. 모든 버튼값 초기화
                        initClickState();
                        // 2. 선택된 버튼에 대한 변수값 및 위젯 update
                        setState(() {
                          isClickPoint5 = true;
                          _priorityPoint = 5;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text("유저피드백(선택사항)"),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  maxLines: 5,
                  maxLength: 500,
                  // 텍스트 필드 데코
                  decoration: InputDecoration(
                    // 내부 입력값 패딩
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffd9d9d9),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "떠오른 아이디어에 대한 \n피드백을 입력하세요 ",
                    hintStyle: TextStyle(
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                  controller: _feedbackEditingController,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 65,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child:
                      Text(widget.ideaInfo == null ? "아이디어 작성하기" : "아이디어 편집하기"),
                ),
                onTap: () {
                  // 데이터 저장 처리
                  ideaInsertPrcss();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 클릭 상태 초기화
  void initClickState() {
    isClickPoint1 = false;
    isClickPoint2 = false;
    isClickPoint3 = false;
    isClickPoint4 = false;
    isClickPoint5 = false;
  }

  //아이디어 저장 프로세스
  Future<void> ideaInsertPrcss() async {
    // 1. 데이터 가져옴
    String titleValue = _titleEditingController.text.toString();
    String motiveValue = _motiveEditingController.text.toString();
    String contentValue = _contentEditingController.text.toString();
    String feedbackValue = _feedbackEditingController.text.toString();
    double priorityPoint = _priorityPoint.toDouble();

    // 2. 유효성 검사
    if (titleValue.isEmpty || motiveValue.isEmpty || contentValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("비어있는 값이 존재합니다."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 3. 데이터 정보 클래스 인스턴스 생성 후 db삽입(insert)
    ///widget.ideaInfo widget 키워드로 stful 위젯에 접근가능
    if (widget.ideaInfo == null) {
      var ideaInfo = IdeaInfo(
        title: titleValue,
        motive: motiveValue,
        content: contentValue,
        priority: priorityPoint,
        feedback: feedbackValue,
        createdDt: DateTime.now().millisecondsSinceEpoch,
        updatedDt: DateTime.now().millisecondsSinceEpoch,
      );

      await setInsertIdeaInfo(ideaInfo);
      // mou
      if (mounted) {
        Navigator.pop(context, "insert");
      }
    } else {
      // 데이터 수정(update)
      var modifyIdeaInfo = widget.ideaInfo;

      modifyIdeaInfo?.title = titleValue;
      modifyIdeaInfo?.motive = motiveValue;
      modifyIdeaInfo?.content = contentValue;
      modifyIdeaInfo?.priority = priorityPoint;
      modifyIdeaInfo?.feedback = feedbackValue ?? "";
      modifyIdeaInfo?.updatedDt = DateTime.now().millisecondsSinceEpoch;

      //modifyIdeaInfo는 절대 null이 아님
      await setUpdateIdeaInfo(modifyIdeaInfo!);

      if (mounted) {
        // close screen
        Navigator.pop(context, "update");
      }
    }
  }

  Future setInsertIdeaInfo(IdeaInfo ideaInfo) async {
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(ideaInfo);
  }

  Future setUpdateIdeaInfo(IdeaInfo ideaInfo) async {
    await dbHelper.initDatabase();
    await dbHelper.updateIdeaInfo(ideaInfo);
  }
}
