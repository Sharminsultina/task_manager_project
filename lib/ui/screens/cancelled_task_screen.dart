import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cancelled_task_controller.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CancelledTaskController>().getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<CancelledTaskController>(
                  builder: (cancelledTaskController) {
                    return Visibility(
                      visible: cancelledTaskController.getCancelledTaskInProgress ==
                          false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                          color: Colors.white,
                        ),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () =>
                            cancelledTaskController.getCancelledTaskList(),
                        child: ListView.builder(
                            itemCount: cancelledTaskController
                                .taskListModel.taskList?.length ??
                                0,
                            itemBuilder: (context, index) {
                              return TaskItemCard(
                                task: cancelledTaskController
                                    .taskListModel.taskList![index],
                                onStatusChange: () {
                                  cancelledTaskController.getCancelledTaskList();
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