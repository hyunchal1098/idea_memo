class IdeaInfo {
  ///변수
  int? id;
  String title; //아이디어 제목
  String motive; //아이디어 동기
  String content; //아이디어 내용
  double priority; //아이디어 점수
  String? feedback; //아이디어 피드백
  int createdDt;
  int updatedDt;

  ///생성자
  IdeaInfo({
    this.id,
    required this.title,
    required this.motive,
    required this.content,
    required this.priority,
    this.feedback,
    required this.createdDt,
    required this.updatedDt,
  }); //아아디어 생성일

  ///map -> key, value  변환
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "motive": motive,
      "content": content,
      "priority": priority,
      "feedback": feedback,
      "createdDt": createdDt,
      "updatedDt": updatedDt,
    };
  }

  ///factory 생성자 : 클래스의 인스턴스를 새로 생성하지않고 캐시에서 인스턴스를 반환받거
  factory IdeaInfo.fromMap(Map<String, dynamic> map) {
    return IdeaInfo(
      id: map["id"],
      title: map["title"],
      motive: map["motive"],
      content: map["content"],
      priority: map["priority"],
      feedback: map["feedback"],
      createdDt: map["createdDt"],
      updatedDt: map["updatedDt"],
    );
  }
}
