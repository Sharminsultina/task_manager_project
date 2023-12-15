import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/completed_task_controller.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CompletedTaskController>().getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<CompletedTaskController>(
                  builder: (completedTaskController) {
                    return Visibility(
                      visible: completedTaskController.getCompletedTaskInProgress ==
                          false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                          color: Colors.white,
                        ),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () =>
                            completedTaskController.getCompletedTaskList(),
                        child: ListView.builder(
                            itemCount: completedTaskController
                                .taskListModel.taskList?.length ??
                                0,
                            itemBuilder: (context, index) {
                              return TaskItemCard(
                                task: completedTaskController
                                    .taskListModel.taskList![index],
                                onStatusChange: () {
                                  completedTaskController.getCompletedTaskList();
                                },
                                showProgress: (inProgress) {},
                              );
                            }),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}