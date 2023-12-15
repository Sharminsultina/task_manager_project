import 'package:get/get.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class AddNewTaskController extends GetxController {
  bool _createTaskInProgress = false;
  String _failedMessage = "";
  String _successMessage = "";

  bool get createTaskInProgress => _createTaskInProgress;

  String get failureMessage => _failedMessage;

  String get successMessage => _successMessage;

  Future<bool> createTask(String title, String description) async {
    _createTaskInProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createNewTask, body: {
      "title": title,
      "description": description,
      "status": "New",
    });
    _createTaskInProgress = false;
    update();
    if (response.isSuccess) {
      _successMessage = "Task added, refresh to show new task list.";
      Get.back();
      return true;
    } else {
      _failedMessage = "Create new task failed! Try again.";
    }
    return false;
  }
}