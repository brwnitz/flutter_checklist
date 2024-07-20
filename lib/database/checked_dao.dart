import 'package:checklist_master/database/databasehelper.dart';
import 'package:checklist_master/models/checked.dart';

class CheckedDao{
  final Databasehelper _databasehelper = Databasehelper();

  Future<void> addItem(Checked? checked) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawInsert(
        'INSERT INTO Checked(nameChecked, descChecked, isChecked, dateChecked, isFavorite, idTopic) VALUES(?,?,?,?,?,?)',
        [checked?.nameChecked, checked?.descChecked, checkBool(checked?.isChecked), checked?.dateChecked, checkBool(checked?.isFavorite), checked!.idTopic], 
      );
  }

  Future<void> deleteItem(int? idChecked) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawDelete('DELETE FROM Checked WHERE idChecked = ?',[idChecked]);
  }

  Future<void> updatedItem(Checked? checked) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawUpdate(
        'UPDATE Checked SET nameChecked = ?, descChecked = ?, isChecked = ?, dateChecked = ?, isFavorite = ? WHERE idChecked = ?',
        [checked?.nameChecked, checked?.descChecked, checkBool(checked?.isChecked), checked?.dateChecked, checkBool(checked?.isFavorite), checked?.idChecked],
      );
  }

  Future<void> deleteFromTopic(int idTopic) async {
    var dbClient = await _databasehelper.db;
    await dbClient.rawDelete('DELETE FROM Checked WHERE idTopic = ?',[idTopic]);
  }

  Future<List<Checked>> getAll() async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked');
    List<Checked> checked = [];
    for (int i = 0; i < list.length; i++) {
      checked.add(Checked(
        idChecked: list[i]['idChecked'],
        nameChecked: list[i]['nameChecked'],
        descChecked: list[i]['descChecked'],
        isChecked: checkInt((list[i]['isChecked'])),
        dateChecked: list[i]['dateChecked'],
        idTopic: list[i]['idTopic'],
        isFavorite: checkInt((list[i]['isFavorite']))
      ));
    }
    return checked;
  }

  Future<List<Checked>> getCheckedByTopic(int idTopic) async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked WHERE idTopic = $idTopic');
    List<Checked> checked = [];
    for (int i = 0; i < list.length; i++) {
      checked.add(Checked(
        idChecked: list[i]['idChecked'],
        nameChecked: list[i]['nameChecked'],
        descChecked: list[i]['descChecked'],
        isChecked: checkInt((list[i]['isChecked'])),
        dateChecked: list[i]['dateChecked'],
        idTopic: list[i]['idTopic'],
        isFavorite: checkInt((list[i]['isFavorite'])),
      ));
    }
    return checked; 
  }

  Future<Checked> getCheckedById(int idChecked) async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked WHERE idChecked = $idChecked');
    return Checked(
      idChecked: list[0]['idChecked'],
      nameChecked: list[0]['nameChecked'],
      descChecked: list[0]['descChecked'],
      isChecked: checkInt((list[0]['isChecked'])),
      dateChecked: list[0]['dateChecked'],
      idTopic: list[0]['idTopic'],
      isFavorite: checkInt((list[0]['isFavorite'])),
    );
  }

  Future<List<Checked>> getAllOrderByDate() async{
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked ORDER BY dateChecked ASC');
    List<Checked> checked = [];
    for (int i = 0; i < list.length; i++) {
      checked.add(Checked(
        idChecked: list[i]['idChecked'],
        nameChecked: list[i]['nameChecked'],
        descChecked: list[i]['descChecked'],
        isChecked: checkInt((list[i]['isChecked'])),
        dateChecked: list[i]['dateChecked'],
        idTopic: list[i]['idTopic'],
        isFavorite: checkInt((list[i]['isFavorite'])),
      ));
    }
    return checked;
  }

  Future<int> checkPercentage() async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked WHERE isChecked = 1');
    List<Map> list2 = await dbClient.rawQuery('SELECT * FROM Checked');
    return (list.length * 100) ~/ list2.length;
  }

  Future<int> getCount() async {
    var dbClient = await _databasehelper.db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Checked');
    return list.length;
  }

  int checkBool(bool? value){
    if(value == true){
      return 1;
    }
    else{
      return 0;
    }
  }

  bool checkInt(int value){
    if(value == 1){
      return true;
    }
    else{
      return false;
    }
  }

}