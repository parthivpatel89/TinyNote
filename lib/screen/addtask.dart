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

  Color _colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.name;
    _descriptionController.text = widget.desc;

    if (widget.dates != '') {
      _dateController.text = widget.dates;
    }

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blueGrey, //change your color here
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: _colorFromHex("#3f4f95"),
          title: Text(
            "Add new thing", //constants.appTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            color:
                _colorFromHex("#3f4f95"), // Color.fromARGB(255, 79, 149, 255),
            child: Form(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 2, color: Colors.blueGrey)),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blueGrey,
                          ),
                        ),

                        //Icon(Icons.edit),
                        SizedBox(height: 24.0),

                        TextFormField(
                          controller:
                              _dateController, //editing controller of this TextField
                          decoration: const InputDecoration(
                            // suffixIcon: IconButton(
                            //   onPressed: _dateController.clear,
                            //   icon: const Icon(Icons.clear),
                            // ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            // icon: Icon(
                            //     Icons.calendar_today), //icon of text field
                            // labelText: "Enter Date",
                            hintText: 'Select  task date',
                            hintStyle: TextStyle(
                              color: Colors.blueGrey,
                            ), //label text of field
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
                          style: const TextStyle(color: Colors.white),
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
                          isLabelEnabled: false,
                          isCapitalized: true,
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
                          isLabelEnabled: false,
                          isCapitalized: true,
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
                              // shape: MaterialStateProperty.all(
                              //   RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10),
                              //   ),
                              // ),
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
                                'ADD YOUR THING',
                                style: TextStyle(
                                  fontSize: 15,
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
            )));
  }
}
