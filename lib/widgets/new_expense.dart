import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
final formatter = DateFormat.yMd();

class  NewExpense extends StatefulWidget{
  const NewExpense(this.onAddExpense,{super.key});
  final void Function (Expense expense) onAddExpense;
  @override
  State<NewExpense> createState(){
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense>{
  final _titleController = TextEditingController();
 final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectCategory = Category.leisure;

 void _presentDatePicker() async { //for future values 
  final now = DateTime.now();
  final pickedDate = await showDatePicker(context: context, 
  initialDate: now, 
  firstDate: DateTime(now.year-1, now.month, now.day), 
  lastDate: DateTime(now.year+1, now.month, now.day)
  );
  //this line will be executed one the future value is available
    setState(() {
      _selectedDate = pickedDate;
    });
 }
  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context,
      builder: (ctx)=>CupertinoAlertDialog(
      title: const Text('Invalid input'),
      content: const Text('Please make sure a valid title, amount, or date was entered'),
      actions: [
        TextButton(
        onPressed: (){Navigator.pop(ctx);}, 
        child: const Text('Okay'))
      ],
     )); // for iOS 
    } else {
    showDialog(
    context: context, 
    builder: (ctx)=> AlertDialog(
      title: const Text('Invalid input'),
      content: const Text('Please make sure a valid title, amount, or date was entered'),
      actions: [
        TextButton(
        onPressed: (){Navigator.pop(ctx);}, 
        child: const Text('Okay'))
      ],
    ),);
    }

  }
  void _submitExpenseDate(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount<= 0;
   if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
    //show error message 
    _showDialog();
    return; 
   }
   widget.onAddExpense(Expense(title: _titleController.text,
    amount: enteredAmount, 
    date: _selectedDate!, 
    category: _selectCategory
    ));

    Navigator.pop(context);
  }


  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(context){
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx,constraints){
      final width = constraints.maxHeight;
      return  SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16,16,16,keyboardSpace+16),
          child: Column(
            children: [
              if(width <=600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                                    controller: _titleController,
                                    maxLength: 50,
                                    keyboardType: TextInputType.text,//defualt dont have to set it
                                    decoration: const InputDecoration(
                        label: Text('Title'),
                                    ),
                                  ),
                    ),
                    const SizedBox(width: 24,),
                    Expanded(
                      child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$',
                        label: Text('Amount'),
                      ),
                                ),
                    ),


                  ],)
              else 
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,//defualt dont have to set it
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if(width <= 600)
                  Row(children: [
                    DropdownButton(
                        value: _selectCategory,
                        items: Category.values.map(
                          (category)=> DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                            )
                        ).toList(), 
                        onChanged: (value){
                          if(value == null){
                            return;
                          }
                        setState(() {
                          _selectCategory = value;
                        });
                        }),
                        const SizedBox(width: 24),
                      Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(_selectedDate == null? 'No Date Selected': formatter.format(_selectedDate!),),
                        IconButton(
                        onPressed: _presentDatePicker, 
                        icon: const Icon(Icons.calendar_month))
                      ],
                      ),
                    ),

                  ],)
                else
                  Row(
                    children:[ 
                      Expanded(
                        child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          label: Text('Amount'),
                        ),
                                  ),
                      ),
                    const SizedBox(width:16),
                      Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text(_selectedDate == null? 'No Date Selected': formatter.format(_selectedDate!),),
                        IconButton(
                        onPressed: _presentDatePicker, 
                        icon: const Icon(Icons.calendar_month))
                      ],
                      ),
                    ),
                    ]
                  ),
                  const SizedBox(height:16),
                  if(width <= 600)
                    Row(
                      children: [
                        const Spacer(),
                      TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancel')),
                      ElevatedButton(onPressed: _submitExpenseDate, 
                      child: const  Text('Save Expense')
                      ),
                      ],
                    )
                  else
                    Row(
                    children: [
                      DropdownButton(
                        value: _selectCategory,
                        items: Category.values.map(
                          (category)=> DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                            )
                        ).toList(), 
                        onChanged: (value){
                          if(value == null){
                            return;
                          }
                        setState(() {
                          _selectCategory = value;
                        });
                        }),
                        const Spacer(),
                      TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancel')),
                      ElevatedButton(onPressed: _submitExpenseDate, 
                      child: const  Text('Save Expense')
                      ),
                  ],)
          
            ]),
      
        ),
      ),
    );
    });
    
    
    
  }
}