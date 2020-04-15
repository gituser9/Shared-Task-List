import 'package:shared_task_list/common/db/db_provider.dart';
import 'package:shared_task_list/model/category.dart';

// TODO: no static
class CategoryProvider {
  static const _categoryTable = 'categories';

  static Future saveList(List<Category> newCategories) async {
    final db = await DBProvider.db.database;
    var savedCategories = Map<String, Category>();
    var oldCategories = await getList();

    for (final cat in oldCategories) {
      savedCategories[cat.name] = cat;
    }

    await db.rawDelete('delete from $_categoryTable');

    var batch = db.batch();

    for (Category category in newCategories) {
      if (savedCategories.containsKey(category.name)) {
        category.colorString = savedCategories[category.name].colorString;
      }
      batch.rawInsert(
        'insert into $_categoryTable (name, color_string) values (?,?)',
        [category.name, category.colorString],
      );
    }

    batch.commit(noResult: true);
  }

  static Future<List<Category>> getList() async {
    var db = await DBProvider.db.database;
    List<Map> maps = await db.query(_categoryTable);
    var lists = List<Category>();

    for (final map in maps) {
      final task = Category.fromMap(map);
      lists.add(task);
    }

    return lists;
  }

  static Future save(Category category) async {
    var db = await DBProvider.db.database;
    var batch = db.batch();
    batch.rawUpdate(
      'update $_categoryTable set name = ?, color_string = ? where id = ?',
      [category.name, category.colorString, category.id],
    );
    batch.commit(noResult: true);
  }
}
