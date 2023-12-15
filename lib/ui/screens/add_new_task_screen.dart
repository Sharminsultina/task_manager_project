import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/add_new_task_controller.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/snack_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddNewTaskController _addNewTaskController =
  Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Add New Task",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _titleTEController,
                            decoration:
                            const InputDecoration(hintText: "Title"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Title Required!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _descriptionTEController,
                            maxLines: 8,
                            decoration:
                            const InputDecoration(hintText: "Description"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Description Required!";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: GetBuilder<AddNewTaskController>(
                                builder: (addNewTaskController) {
                                  return Visibility(
                                    visible:
                                    addNewTaskController.createTaskInProgress ==
                                        false,
                                    replacement: const Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: createTask,
                                      child: const Icon(
                                        CupertinoIcons.arrow_up_circle_fill,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await _addNewTaskController.createTask(
        _titleTEController.text.trim(), _descriptionTEController.text.trim());
    if (response) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        showSnackMessage(context, _addNewTaskController.successMessage);
      }
    } else {
      if (mounted) {
        showSnackMessage(context, _addNewTaskController.failureMessage);
      }
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}