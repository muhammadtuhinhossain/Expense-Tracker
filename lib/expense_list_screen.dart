import 'package:expense_tracker/expense_model.dart';
import 'package:expense_tracker/expense_screen.dart';
import 'package:expense_tracker/shared_pref_service.dart';
import 'package:flutter/material.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {

  final TextEditingController titleController= TextEditingController();
  final TextEditingController amountController= TextEditingController();
  List<ExpenseModel> expenses = [];

  Future<void> loadExpenses() async{
    expenses = await SharedPrefService.getExpenses();
    setState(() {

    });
  }

  @override
  void initState() {
    loadExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
          itemBuilder: (context, index){
          final expense = expenses[index];
          return Card(
            child: ListTile(
              title: Text(expense.title),
              subtitle: Text('${expense.category}  ${expense.date}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('৳ ${expense.amount}'),
                  IconButton(onPressed: ()async{
                    expenses.removeAt(index);
                    await SharedPrefService.saveExpenses(expenses);
                    setState(() {

                    });
                  }, icon: Icon(Icons.delete)),
                ],
              ),
              leading: IconButton(onPressed: ()async{
                await Navigator.push(context, MaterialPageRoute(builder: (_)=> ExpenseScreen(expense: expense,index: index,),),);
                loadExpenses();
              }, icon: Icon(Icons.edit)),
            ),
          );
          }
      ),


      floatingActionButton: FloatingActionButton(onPressed: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (_)=> ExpenseScreen(),));
        loadExpenses();
      },child: Icon(Icons.add),),
    );
  }
}

