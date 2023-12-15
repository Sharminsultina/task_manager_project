import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/models/task_count_summary_list_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class NewTaskController extends GetxController {
  bool _getNewTaskInProgress = false;
  bool _getTaskCountSummaryInProgress = false;
  TaskListModel _taskListModel = TaskListModel();
  TaskCountSummaryListModel _taskCountSummaryListModel =
  TaskCountSummaryListModel();

  bool get getNewTaskInProgress => _getNewTaskInProgress;

  bool get getTaskCountSummaryInProgress => _getTaskCountSummaryInProgress;

  TaskListModel get taskListModel => _taskListModel;

  TaskCountSummaryListModel get taskCountSummaryListModel =>
      _taskCountSummaryListModel;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();

    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getNewTasks);
    _getNewTaskInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }

  Future<bool> getTaskCountSummaryList() async {
    bool isSuccess = false;
    _getTaskCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    _getTaskCountSummaryInProgress = false;
    if (response.isSuccess) {
      _taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
      _taskCountSummaryListModel.taskCountList;
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}