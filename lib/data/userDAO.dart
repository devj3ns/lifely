import 'package:sembast/sembast.dart';

import 'database.dart';
import 'userModel.dart';

class UserDao {
  static const String folderName = "UserData";
  final _userFolder = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future updateOrInsert(User user) async {
    await _userFolder.record(1).put(await _db, user.toJson(), merge: true);
    print('##DB user inserted/updated successfully !!');
  }

  Future delete() async {
    await _userFolder.record(1).delete(await _db);
    print('##DB user deleted successfully !!');
  }

  Future<User> getUser() async {
    final value = await _userFolder.record(1).get(await _db);
    return User.fromJson(value);
  }
}
