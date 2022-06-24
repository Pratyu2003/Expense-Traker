import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptiveFlatButton.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null)
      return;

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });

      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Container(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.add_circle_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              Padding(padding: EdgeInsetsDirectional.only(bottom: 8)),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.money_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                      ),
                    ),
                  AdaptiveFlatButtton('Choose Date', _presentDatePicker)
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Center(
                child: ButtonTheme(
                  padding: EdgeInsets.all(15),
                  minWidth: MediaQuery.of(context).size.width * 0.02,
                  height: MediaQuery.of(context).size.height * 0.02,
                  buttonColor: Colors.blueAccent,
                  child: RaisedButton(
                    child: Text(
                      'Add Transaction',
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Color.fromARGB(255, 255, 255, 255),
                    onPressed: _submitData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
