import 'package:sembast/sembast.dart';

import 'database.dart';
import 'goalModel.dart';

class GoalsDao {
  static const String folderName = "GoalsData";
  final _goalFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future updateOrInsert(Goal goal) async {
    await _goalFolder
        .record(goal.id)
        .put(await _db, goal.toJson(), merge: true);
    print('##DB goal inserted/updated successfully !!');
  }

  Future delete(Goal goal) async {
    await _goalFolder.record(goal.id).delete(await _db);
    print('##DB goal deleted successfully !!');
  }

  Future<List<Goal>> getAllGoals() async {
    final recordSnapshot = await _goalFolder.find(await _db);
    return recordSnapshot.map((snapshot) {
      final goal = Goal.fromJson(snapshot.value);
      return goal;
    }).toList();
  }

  Future deleteAll() async {
    await _goalFolder.delete(await _db);
    print('##DB goal folder deleted successfully !!');
  }
}
