import 'package:idea_memo/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  ///late : 초기화 되지 않은 값으로 변수선언가능, 특정시점에 초기화 할 거라는 명시적 의미
  late Database database;

  Future<void> initDatabase() async {
    final String dbPath = await getDatabasesPath();
    //데이터베이스 파일경로 가져오기
    final String path = join(dbPath, "archive_idea.db");

    //데이터베이스 열기
    database = await openDatabase(
      //데이터베이스 파일경로
      path,
      //데이터베이스 버전
      version: 1,
      onCreate: (db, version) {
        //데이터베이스가 생성될때 실행되는 코드
        db.execute("""
        CREATE TABLE IF NOT EXISTS tb_idea (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          motive TEXT,
          content TEXT,
          priority REAL,
          feedback TEXT,
          createdDt INTEGER,
          updatedDt INTEGER
        )
      """);
      },
    );
  }

  //데이터 삽입
  Future<int> insertIdeaInfo(IdeaInfo ideaInfo) async {
    return await database.insert("tb_idea", ideaInfo.toMap());
  }

  //데이터 조회
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await database.query("tb_idea");
    return List.generate(result.length, (index) {
      return IdeaInfo.fromMap(result[index]);
    });
  }

  //데이터 수정
  Future<int> updateIdeaInfo(IdeaInfo ideaInfo) async {
    return await database.update(
      "tb_idea",
      ideaInfo.toMap(),
      where: "id=?",
      whereArgs: [ideaInfo.id],
    );
  }

  //데이터 삭제
  Future<int> deleteIdeaInfo(int id) async {
    return await database.delete(
      "tb_idea",
      where: "id=?",
      whereArgs: [id],
    );
  }

  ///데이터베이스 닫기
  Future<void> closeDatabase() async {
    await database.close();
  }
}
