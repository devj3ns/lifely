import 'package:sembast/sembast.dart';

import 'database.dart';
import 'goalModel.dart';

class BigFivesDao {
  static const String folderName = "BigFivesData";
  final _bigFiveFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future updateOrInsert(Goal goal) async {
    await _bigFiveFolder
        .record(goal.id)
        .put(await _db, goal.toJson(), merge: true);
    print('##DB bf inserted/updated successfully !!');
  }

  Future delete(Goal goal) async {
    await _bigFiveFolder.record(goal.id).delete(await _db);
    print('##DB bf deleted successfully !!');
  }

  Future<List<Goal>> getAllBigFives() async {
    final recordSnapshot = await _bigFiveFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final goal = Goal.fromJson(snapshot.value);
      return goal;
    }).toList();
  }

  Future deleteAll() async {
    await _bigFiveFolder.delete(await _db);
    print('##DB bf folder deleted successfully !!');
  }
}
