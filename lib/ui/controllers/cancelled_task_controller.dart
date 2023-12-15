import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCancelledTaskInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;

  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _getCancelledTaskInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getCancelledTasks);
    _getCancelledTaskInProgress = false;
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}