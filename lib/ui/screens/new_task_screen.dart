import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/models/task_count.dart';
import '../controllers/new_task_controller.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';
import '../widgets/summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({
    super.key,
  });

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool taskCountChange = false;
  final NewTaskController _newTaskController = Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    _newTaskController.getNewTaskList();
    _newTaskController.getTaskCountSummaryList();
  }

  Future<void> _refresh() async {
    _newTaskController.getNewTaskList();
    _newTaskController.getTaskCountSummaryList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pop(context, taskCountChange);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            final response = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewTaskScreen(),
              ),
            );
            if (response != null && response == true) {
              Get.find<NewTaskController>().getNewTaskList();
              Get.find<NewTaskController>().getTaskCountSummaryList();
            }
          },
          child: const Icon(
            CupertinoIcons.add_circled_solid,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummaryCard(),
              GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible:
                  newTaskController.getTaskCountSummaryInProgress == false,
                  replacement: const LinearProgressIndicator(
                    backgroundColor: Colors.green,
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newTaskController.taskCountSummaryListModel
                            .taskCountList?.length ??
                            0,
                        itemBuilder: (context, index) {
                          TaskCount taskCount = newTaskController
                              .taskCountSummaryListModel.taskCountList![index];
                          return FittedBox(
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 12, right: 12),
                              child: SummaryCard(
                                count: taskCount.sum.toString(),
                                title: taskCount.sId ?? "",
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }),
              Expanded(
                child:
                GetBuilder<NewTaskController>(builder: (newTaskController) {
                  return Visibility(
                    visible: newTaskController.getNewTaskInProgress == false &&
                        (newTaskController.taskCountSummaryListModel
                            .taskCountList?.isNotEmpty ??
                            false),
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        color: Colors.white,
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () => _refresh(),
                      child: ListView.builder(
                          itemCount: newTaskController
                              .taskListModel.taskList?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return TaskItemCard(
                              task: newTaskController
                                  .taskListModel.taskList![index],
                              onStatusChange: () {
                                newTaskController.getNewTaskList();
                                newTaskController.getTaskCountSummaryList();
                              },
                              showProgress: (inProgress) {},
                            );
                          }),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}