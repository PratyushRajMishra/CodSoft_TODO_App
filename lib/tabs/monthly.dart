import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyTimeController extends GetxController {
  var selectedMonth = ''.obs;

  void setSelectedMonth(String month) {
    selectedMonth.value = month;
  }
}

class MonthlyPage extends StatelessWidget {
  final MonthlyTimeController timeController = Get.put(MonthlyTimeController());
  final TextEditingController headingController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('monthlytasks');

  List<Map<String, String>> dropDownListData = [
    {"title": "January", "value": "January"},
    {"title": "February", "value": "February"},
    {"title": "March", "value": "March"},
    {"title": "April", "value": "April"},
    {"title": "May", "value": "May"},
    {"title": "June", "value": "June"},
    {"title": "July", "value": "July"},
    {"title": "August", "value": "August"},
    {"title": "September", "value": "September"},
    {"title": "October", "value": "October"},
    {"title": "November", "value": "November"},
    {"title": "December", "value": "December"},
  ];

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 370,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  const Text(
                    'Add new Task',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: headingController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.topic,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Enter Heading',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: taskController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.event_note,
                        color: Colors.grey,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Enter task',
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: timeController.selectedMonth.value,
                            isDense: true,
                            isExpanded: true,
                            menuMaxHeight: 350,
                            items: [
                              const DropdownMenuItem(
                                child: Text(
                                  "Select Month",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                value: "",
                              ),
                              ...dropDownListData
                                  .map<DropdownMenuItem<String>>((data) {
                                return DropdownMenuItem(
                                  child: Text(data['title']!),
                                  value: data['value'],
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              print("Selected value $value");
                              timeController.setSelectedMonth(value!);
                            },
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.purple,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        final heading = headingController.text;
                        final task = taskController.text;
                        final selectedMonth =
                            timeController.selectedMonth.value;

                        if (heading.isNotEmpty &&
                            task.isNotEmpty &&
                            selectedMonth.isNotEmpty) {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            final userId = user?.uid;

                            if (userId != null) {
                              // Create a reference to the Firestore collection
                              final taskCollection = FirebaseFirestore.instance
                                  .collection('monthlytasks');

                              await taskCollection.add({
                                'userId': userId,
                                'heading': heading,
                                'task': task,
                                'selectedMonth': selectedMonth,
                                'isFavorite': false,
                                'isComplete': false, // Initially set to false
                              });

                              headingController.clear();
                              taskController.clear();
                              timeController.setSelectedMonth("");

                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            print("Error saving task: $e");
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill in all fields"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot>? getTasksStream() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId != null) {
      return FirebaseFirestore.instance
          .collection('monthlytasks')
          .where('userId', isEqualTo: userId)
          .snapshots();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: getTasksStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final taskDocs = snapshot.data?.docs;

              return ListView.builder(
                itemCount: taskDocs?.length,
                itemBuilder: (context, index) {
                  final taskData =
                      taskDocs?[index].data() as Map<String, dynamic>;
                  final heading = taskData['heading'];
                  final task = taskData['task'];
                  final selectedMonth = taskData['selectedMonth'];
                  final isFavorite = taskData['isFavorite'] ?? false;
                  final isComplete = taskData['isComplete'] ?? false;

                  return Container(
                    margin: const EdgeInsets.only(
                        top: 8, bottom: 0, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        heading,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5),
                      ),
                      subtitle: Text(
                        task,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Month: $selectedMonth'),
                          const SizedBox(width: 5),
                          Visibility(
                            visible: isFavorite,
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                          Visibility(
                            visible: isComplete,
                            child: Icon(
                              Icons.check,
                              color: Colors.green, // Customize the color for completed tasks
                            ),
                          ),

                        ],
                      ),
                      onLongPress: () {
                        _showTaskOptionsDialog(taskDocs?[index].id, heading, isFavorite, isComplete);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () => _showBottomSheet(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}


void _showTaskOptionsDialog(String? taskId, String heading, bool isFavorite, bool isComplete) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete"),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(taskId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit"),
              onTap: () {
                Navigator.pop(context);
                _editTask(taskId);
              },
            ),
            ListTile(
              leading: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              title: Text(isFavorite ? "Remove from Favorite" : "Add to Favorite"),
              onTap: () {
                Navigator.pop(context);
                _toggleFavoriteStatus(taskId, isFavorite);
              },
            ),
            ListTile(
              leading: Icon(isComplete ? Icons.remove_done_sharp : Icons.done),
              title: Text(isComplete ? "Task not completed!" : "Mark as complete"),
              onTap: () {
                Navigator.pop(context);
                _toggleCompleteStatus(taskId, isComplete);
              },
            ),
          ],
        ),
      );
    },
  );
}


void _toggleCompleteStatus(String? taskId, bool isComplete) {
  if (taskId != null) {
    try {
      // Update the task document to toggle the "isComplete" status
      final taskRef = FirebaseFirestore.instance.collection('monthlytasks').doc(taskId);
      taskRef.update({
        'isComplete': !isComplete,
      });
    } catch (e) {
      print("Error toggling complete status: $e");
    }
  }
}


void _editTask(String? taskId) {

  TextEditingController updatedHeadingController = TextEditingController();
  TextEditingController updatedTaskController = TextEditingController();
  final MonthlyTimeController timeController = Get.put(MonthlyTimeController());

  List<Map<String, String>> dropDownListData = [
    {"title": "January", "value": "January"},
    {"title": "February", "value": "February"},
    {"title": "March", "value": "March"},
    {"title": "April", "value": "April"},
    {"title": "May", "value": "May"},
    {"title": "June", "value": "June"},
    {"title": "July", "value": "July"},
    {"title": "August", "value": "August"},
    {"title": "September", "value": "September"},
    {"title": "October", "value": "October"},
    {"title": "November", "value": "November"},
    {"title": "December", "value": "December"},
  ];



  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 370,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
              const Text(
              'Edit Task',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: updatedHeadingController,
              // No need to change the initial value, as it's set based on the existing task data
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.topic,
                  color: Colors.grey,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Edit Heading',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: updatedTaskController,
              // No need to change the initial value, as it's set based on the existing task data
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.event_note,
                  color: Colors.grey,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'Edit Task',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          InputDecorator(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
            child: Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: timeController.selectedMonth.value,
                isDense: true,
                isExpanded: true,
                menuMaxHeight: 350,
                items: [
                  const DropdownMenuItem(
                    child: Text(
                      "Select Month",
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: "",
                  ),
                  ...dropDownListData
                      .map<DropdownMenuItem<String>>((data) {
                    return DropdownMenuItem(
                      child: Text(data['title']!),
                      value: data['value'],
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  print("Selected value $value");
                  timeController.setSelectedMonth(value!);
                },
              ),
            )),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 350,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: Colors.purple,
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                final updatedHeading = updatedHeadingController.text;
                final updatedTask = updatedTaskController.text;
                final updatedSelectedMonth = timeController.selectedMonth.value;

                if (taskId != null &&
                    updatedHeading.isNotEmpty &&
                    updatedTask.isNotEmpty &&
                    updatedSelectedMonth.isNotEmpty) {
                  try {
                    // Update the task document in Firestore with the new data
                    FirebaseFirestore.instance.collection('monthlytasks').doc(taskId).update({
                      'heading': updatedHeading,
                      'task': updatedTask,
                      'selectedMonth': updatedSelectedMonth,
                    });

                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Error updating task: $e");
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in all fields"),
                    ),
                  );
                }
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          ],
        ),
      ),
      ),
      );
    },
  );
}




void _toggleFavoriteStatus(String? taskId, bool isFavorite) {
  if (taskId != null) {
    try {
      // Update the task document to toggle the "favorite" status
      final taskRef = FirebaseFirestore.instance.collection('monthlytasks').doc(taskId);
      taskRef.get().then((taskDoc) {
        if (taskDoc.exists) {
          taskRef.update({
            'isFavorite': !isFavorite,
          });
        } else {
          print('Task document not found');
        }
      }).catchError((error) {
        print("Error toggling favorite status: $error");
      });
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }
}





void _showDeleteConfirmationDialog(String? taskId) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _deleteTask(taskId);
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}


void _deleteTask(String? taskId) {
  if (taskId != null) {
    try {
      FirebaseFirestore.instance.collection('monthlytasks').doc(taskId).delete();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
