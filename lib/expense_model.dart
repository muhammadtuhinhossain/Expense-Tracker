import 'dart:convert';

class ExpenseModel {
  String title;
  String amount;
  String category;
  String date;
  String note;

  ExpenseModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap(){
    return{
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'note': note,
    };
  }
  factory ExpenseModel.fromMap(Map<String, dynamic> map){
    return ExpenseModel(
        title: map['title'],
        amount: map['amount'],
        category: map['category'],
        date: map['date'],
        note: map['note']
    );
  }
  String toJson() => jsonEncode(toMap());

  factory ExpenseModel.fromJson(String source)=>
      ExpenseModel.fromMap(jsonDecode(source));
}