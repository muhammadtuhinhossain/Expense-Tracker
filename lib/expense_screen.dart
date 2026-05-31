import 'package:expense_tracker/expense_model.dart';
import 'package:expense_tracker/shared_pref_service.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;
  final int? index;
  const ExpenseScreen({super.key, this.expense, this.index});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  final TextEditingController titleTEController= TextEditingController();
  final TextEditingController amountTEController= TextEditingController();
  final TextEditingController noteTEController= TextEditingController();

  String selectedCategory = 'Food';
  String selectedDate = '';

  List<ExpenseModel> expenses = [];

  List<String> categories=[
    'Food',
    'Shopping',
    'Transport',
    'Entertainment',
  ];

  Future<void> loadExpenses() async{
    expenses = await SharedPrefService.getExpenses();
    setState(() {

    });
  }

  Future<void> pickDate()async{
    DateTime? pickedDate= await showDatePicker(
        context: context,
        firstDate: DateTime(2024),
        lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if(pickedDate != null){
      selectedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {

      });
    }
  }

  void addExpense() async{
    if(_formKey.currentState!.validate()){
      ExpenseModel expense= ExpenseModel(
          title: titleTEController.text,
          amount: amountTEController.text,
          category: selectedCategory,
          date: selectedDate,
          note: noteTEController.text
      );
      expenses.add(expense);
      await SharedPrefService.saveExpenses(expenses);
      clearFields();
      setState(() {

      });
    }
  }
  Future<void> updateExpense()async{
    expenses[widget.index!] = ExpenseModel(
        title: titleTEController.text,
        amount: amountTEController.text,
        category: selectedCategory,
        date: selectedDate,
        note: noteTEController.text,
    );
    await SharedPrefService.saveExpenses(expenses);
  }

  void clearFields(){
    titleTEController.clear();
    amountTEController.clear();
    noteTEController.clear();
    selectedDate='';
  }

  @override
  void initState() {
    loadExpenses();
    super.initState();

    if(widget.expense != null){
      titleTEController.text = widget.expense!.title;
      amountTEController.text = widget.expense!.amount;
      noteTEController.text = widget.expense!.note;

      selectedCategory = widget.expense!.category;
      selectedDate = widget.expense!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleTEController,
                decoration: InputDecoration(
                  hintText: 'Expense Title'
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),

              TextFormField(
                controller: amountTEController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Amount'
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Enter amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),

              DropdownButtonFormField(
                value: selectedCategory,
                  items: categories.map((e){
                    return DropdownMenuItem(
                      value: e,
                        child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value){
                  selectedCategory = value!;
                  },
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: noteTEController,
                decoration: InputDecoration(
                    hintText: 'Note'
                ),
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate.isEmpty
                        ? 'No Date Chosen'
                        : selectedDate,
                  ),
                  ElevatedButton(onPressed: pickDate, child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: ()async{
                if(widget.expense == null){
                  addExpense();
                }else{
                 await updateExpense();
                }
                Navigator.pop(context);
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.expense == null ? Colors.green : Colors.blue,
                ),
                child: Text(widget.expense == null ?'Add Expense': 'Update Expense',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
