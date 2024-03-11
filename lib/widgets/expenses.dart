//Main interface
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});
  @override
  State<Expenses> createState(){
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
 final List<Expense> _dummyValues = [
  Expense(title: 'Flutter Course', 
  amount: 19.99, 
  date: DateTime.now(), 
  category: Category.food),
    Expense(title: 'Cinema', 
  amount: 15.99, 
  date: DateTime.now(), 
  category: Category.leisure),
 ];
  

  void _oppenAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context, 
      builder: (ctx)=>  NewExpense(_addExpense),
      constraints: const BoxConstraints(maxWidth: double.infinity),

      );
      
  }

  void _addExpense(Expense expense){
    setState(() {
      _dummyValues.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _dummyValues.indexOf(expense);
    setState(() {
      _dummyValues.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted.'),
      action: SnackBarAction(
      label: 'Undo', 
      onPressed: (){
        setState(() {
          _dummyValues.insert(expenseIndex,expense);
        });
      }),

    ));
  }

  @override
  Widget build(context){
    final width = 
    MediaQuery.of(context).size.width;
    Widget mainContent = const
    Center(child: Text('No expenses found. Start adding some!'));

    if(_dummyValues.isNotEmpty){
      mainContent = ExpensesList(_removeExpense,
            listOfExpenses: _dummyValues);

    }
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
        IconButton(
          onPressed: _oppenAddExpenseOverlay,
          icon: const Icon(Icons.add),
          )
      ]),
      body: width < 600 ? Column(
        children:[
          Chart(expenses: _dummyValues),
          Expanded(
          child: mainContent
          ),
        ],
        ): Row(children: [
          Expanded(child: Chart(expenses: _dummyValues)),
          Expanded(
          child: mainContent
          ),
        ]),
    );
  }
}