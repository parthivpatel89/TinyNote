import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinynote/controller/constants.dart';

import '../controller/database.dart';
import '../controller/validator.dart';
import '../widgets/customfield.dart';

class AddTask extends StatefulWidget {
  final String documentId;
  final String name;
  final String desc;
  final String dates;
  final String uid;

  const AddTask(
      {required this.documentId,
      required this.name,
      required this.desc,
      required this.dates,
      required this.uid});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _addItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.name;
    _descriptionController.text = widget.desc;

    if (widget.dates != '') {
      _dateController.text = widget.dates;
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: constants.firebaseNavy,
          title: Text(constants.appTitle),
        ),
        body: Form(
          key: _addItemFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.0),

                    TextField(
                      controller:
                          _dateController, //editing controller of this TextField
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            _dateController.text = formattedDate
                                .toString(); //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),

                    // Text(
                    //   'Title',
                    //   style: TextStyle(
                    //     color: constants.hint,
                    //     fontSize: 22.0,
                    //     letterSpacing: 1,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(height: 8.0),
                    CustomField(
                      isLabelEnabled: true,
                      controller: _titleController,
                      // focusNode: widget.titleFocusNode,
                      keyboardType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      validator: (value) => Validator.validateField(
                        value: value,
                      ),
                      label: 'Task Name',
                      hint: 'Enter your task name',
                    ),
                    SizedBox(height: 24.0),
                    // Text(
                    //   'Description',
                    //   style: TextStyle(
                    //     color: constants.hint,
                    //     fontSize: 22.0,
                    //     letterSpacing: 1,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(height: 8.0),
                    CustomField(
                      maxLines: 5,
                      isLabelEnabled: true,
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      validator: (value) => Validator.validateField(
                        value: value,
                      ),
                      label: 'Description',
                      hint: 'Enter your task description',
                    ),
                    SizedBox(height: 8.0),
                    // CustomField(
                    //   maxLines: 1,
                    //   isLabelEnabled: false,
                    //   controller: _dateController,
                    //   // focusNode: widget.descriptionFocusNode,
                    //   keyboardType: TextInputType.text,
                    //   inputAction: TextInputAction.done,
                    //   validator: (value) => Validator.validateField(
                    //     value: value,
                    //   ),
                    //   label: 'Date',
                    //   hint: 'Enter date for task',
                    // ),
                  ],
                ),
              ),
              _isProcessing
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          constants.firebaseNavy,
                        ),
                      ),
                    )
                  : Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            constants.firebaseNavy,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // widget.titleFocusNode.unfocus();
                          // widget.descriptionFocusNode.unfocus();

                          if (_addItemFormKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });

                            if (widget.documentId == '') {
                              await Database.addItem(
                                  task: _titleController.text,
                                  description: _descriptionController.text,
                                  dates: _dateController.text,
                                  uid: widget.uid);
                            } else {
                              await Database.updateItem(
                                  task: _titleController.text,
                                  description: _descriptionController.text,
                                  dates: _dateController.text,
                                  docId: widget.documentId);
                            }

                            setState(() {
                              _isProcessing = false;
                            });

                            Navigator.of(context).pop();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            'Add Task',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: constants.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
