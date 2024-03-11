import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';


class ExpensesList extends StatelessWidget{
  const ExpensesList(this.onRemoveExpense,{super.key, required this.listOfExpenses});
  final List<Expense> listOfExpenses;
  final Function(Expense expense) onRemoveExpense;
  @override
  Widget build(context){
    return ListView.builder(
      itemCount: listOfExpenses.length,
      itemBuilder: (context, index) => 
      Dismissible(
        background: Container(color: Theme.of(context).colorScheme.error.withOpacity(0.75),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
      onDismissed: (direction){
        onRemoveExpense(listOfExpenses[index]);
      },
      key: ValueKey(listOfExpenses[index]),
      child:
       ExpenseItem(expense: listOfExpenses[index])
       ),
    );
  }
}