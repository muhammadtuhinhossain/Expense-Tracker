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
  double budget = 0.0;

  Future<void> loadExpenses() async{
    expenses = await SharedPrefService.getExpenses();
    budget = await SharedPrefService.getBudget();
    setState(() {

    });
  }
  double getTotalExpense(){
    return expenses.fold(0.0, (sum, expense){
      return sum + (double.tryParse(expense.amount) ?? 0.0);
    });
  }
  double getRemaining(){
    return budget - getTotalExpense();
  }
  void showBudgetDialog(){
    final controller= TextEditingController(
      text: budget > 0 ? budget.toStringAsFixed(0) : '',
    );
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Add Money'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Add money',prefixText: '৳'
        ),
      ),
      actions: [
        TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: ()async{
          final value = double.tryParse(controller.text);
          if (value != null) {
            await SharedPrefService.saveBudget(value);
            await loadExpenses();
            Navigator.pop(context);
          }
        }, child: Text('Add Taka')),
      ],
    ));
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
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(onPressed: showBudgetDialog, icon: Icon(Icons.account_balance_wallet),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Container(
              color: Colors.orange.shade700,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Budget: ৳ ${budget.toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text('Expense: ৳ ${getTotalExpense().toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                  Text('Due: ৳ ${getRemaining().toStringAsFixed(0)}',
                    style: TextStyle(
                      color: getRemaining() < 0 ? Colors.red.shade400 : Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
      body:Column(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            color: Colors.orange.shade100,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Expense',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text('৳ ${getTotalExpense().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index){
                  final expense = expenses[index];
                  return Card(
                    elevation: 6,
                    color: Colors.blueGrey.shade100,
                    child: ListTile(
                      title: Text(expense.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${expense.category}  ${expense.date}'),
                          Text(expense.note,style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('৳ ${expense.amount}'),
                          IconButton(onPressed: ()async{
                            expenses.removeAt(index);
                            await SharedPrefService.saveExpenses(expenses);
                            setState(() {

                            });
                          }, icon: Icon(Icons.delete,color: Colors.red,)),
                        ],
                      ),
                      leading: IconButton(onPressed: ()async{
                        await Navigator.push(context, MaterialPageRoute(builder: (_)=> ExpenseScreen(expense: expense,index: index,),),);
                        loadExpenses();
                      }, icon: Icon(Icons.edit,size: 16,color: Colors.blue,)),
                    ),
                  );
                }
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(onPressed: ()async{
        await Navigator.push(context, MaterialPageRoute(builder: (_)=> ExpenseScreen(),));
        loadExpenses();
      },child: Icon(Icons.add),),
    );
  }
}

