import 'package:checklist_master/database/databasehelper.dart';
import 'package:checklist_master/models/topic.dart';

class TopicDao{
  final Databasehelper _databasehelper = Databasehelper();

  Future<void> addTopic(String titleTopic, String descTopic, int colorTopic) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawInsert(
        'INSERT INTO Topic(titleTopic, descTopic, colorTopic) VALUES(? , ?, ?)',
        [titleTopic, descTopic, colorTopic],
      );
    }

  Future<void> deleteTopic(int idTopic) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawDelete('DELETE FROM Topic WHERE idTopic = ?',[idTopic]);
  }

  Future<void> updateTopic(int idTopic, String titleTopic, String descTopic, int colorTopic) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawUpdate(
        'UPDATE Topic SET titleTopic = ?, descTopic = ?, colorTopic = ? WHERE idTopic = ?', [titleTopic, descTopic, idTopic, colorTopic],
      );
  }

  Future<List<Topic>> getAll() async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Topic');
    return List.generate(list.length, (i) {
      return Topic(
        idTopic: list[i]['idTopic'],
        titleTopic: list[i]['titleTopic'],
        descTopic: list[i]['descTopic'],
        colorTopic: list[i]['colorTopic'],
      );
    });
  }

  Future<Topic> getTopic(int idTopic) async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Topic WHERE idTopic = $idTopic');
    return Topic(
      idTopic: list[0]['idTopic'],
      titleTopic: list[0]['titleTopic'],
      descTopic: list[0]['descTopic'],
      colorTopic: list[0]['colorTopic'],
    );
  }

  Future<int> getColor(int idTopic) async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT colorTopic FROM Topic WHERE idTopic = $idTopic');
    return list[0]['colorTopic'];
  }

  Future<int> getCount() async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Topic');
    return list.length;
  }
  
}