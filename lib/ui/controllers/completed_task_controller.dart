import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTaskInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;

  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _getCompletedTaskInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCompletedTasks);
    _getCompletedTaskInProgress = false;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}