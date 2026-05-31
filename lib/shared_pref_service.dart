import 'package:expense_tracker/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static String key= 'expense_list';

  static Future<void> saveExpenses(List<ExpenseModel> expenses)async{
    final prefs= await SharedPreferences.getInstance();

    List<String> expenseList= expenses.map((e)=> e.toJson()).toList();
    await prefs.setStringList(key, expenseList);
  }

  static Future<List<ExpenseModel>>getExpenses()async{
    final prefs= await SharedPreferences.getInstance();
    
    List<String> expenseList= prefs.getStringList(key) ?? [];

    return expenseList .map((e)=> ExpenseModel.fromJson(e)).toList();
  }
}