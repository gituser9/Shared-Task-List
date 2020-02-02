import 'package:rxdart/rxdart.dart';
import 'package:shared_task_list/model/category.dart';
import 'package:shared_task_list/model/settings.dart';
import 'package:shared_task_list/settings/settings_repository.dart';

class SettingsBloc {
  final _repository = SettingsRepository();
  final categories = BehaviorSubject<List<Category>>();
  final category = BehaviorSubject<String>();
  final name = BehaviorSubject<String>();

  Future<Settings> getSettings() async {
    return await _repository.getSettings();
  }

  Future saveSettings(Settings settings) async {
    await _repository.saveSettings(settings);
  }

  void close() {
    categories.close();
    category.close();
    name.close();
  }
}