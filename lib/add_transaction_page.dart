import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_expense_manager/db_helper.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {


  int? amount;
  String note = "Expence";
  String type = "Income";

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];


  _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (selected != null && selected != selectedDate) {
      _dateController.text =
      "${selected.day} - ${months[selectedDate.month - 1]} - ${selected.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Add Transaction Here",textAlign: TextAlign.center,
          style: TextStyle(fontSize:20, color: Colors.white, letterSpacing: .5),),
        centerTitle: true,
      ),


      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                SizedBox(height: 20,),
                TextFormField(
                  controller: _moneyController,

                  validator: (value){
                    if (value!.isEmpty) {
                      return "Required";
                    }
                  },

                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.amber),


                  onChanged: (val){
                    try{
                      amount = int.parse(val);
                    }catch(e){}
                  },


                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),

                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.amber),

                    prefixIcon: Align(
                      widthFactor: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.amber
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.monetization_on_outlined,color: Colors.white,),
                          ),

                      ),
                    ),
                  ),
                ),



                SizedBox(height: 10,),
                TextFormField(
                  controller: _noteController,

                  validator: (value){
                    if (value!.isEmpty) {
                      return "Required";
                    }
                  },

                  /*inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.amber),*/
                  style: TextStyle(color: Colors.amber),

                  onChanged: (val){
                    try{
                      note = val;
                    }catch(e){}
                  },

                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),

                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    hintText: 'Note Transaction',
                    hintStyle: TextStyle(color: Colors.amber),

                    prefixIcon: Align(
                      widthFactor: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.amber
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.sticky_note_2_outlined,color: Colors.white,),
                        ),

                      ),
                    ),
                  ),
                ),


                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 17,top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.amber
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.auto_graph_sharp,color: Colors.white,),
                        ),

                      ),
                    ),


                    SizedBox(width: 12,),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ChoiceChip(
                        selectedColor: Colors.amber,
                          label: Text("Income", style: TextStyle( color: type == "Income" ? Colors.white : Colors.black,),),
                        selected: type == "Income" ? true: false,

                        onSelected: (val){
                          if(val){
                            setState(() {
                              type = "Income";
                            });
                          }
                        },
                      ),
                    ),

                    SizedBox(width: 12,),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ChoiceChip(
                        selectedColor: Colors.amber,
                        label: Text("Expense", style: TextStyle( color: type == "Expense" ? Colors.white : Colors.black,),),
                        selected: type == "Expense" ? true: false,

                        onSelected: (val){
                          if(val){
                            setState(() {
                              type = "Expense";
                            });
                          }
                        },
                      ),
                    ),

                  ],
                ),


                SizedBox(height: 10,),
                TextFormField(
                  controller: _dateController,

                  validator: (value){
                    if (value!.isEmpty) {
                      return "Required";
                    }
                  },

                  /*inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.amber),*/
                  style: TextStyle(color: Colors.amber),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 18,top: 12,bottom: 12,right: 16),

                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    hintText: 'Select Date',
                    hintStyle: TextStyle(color: Colors.amber),

                    suffixIcon: Align(
                      widthFactor: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.amber
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            onPressed: () => _selectDate(context),
                            icon: Icon(Icons.calendar_month_rounded,color: Colors.white,),
                          ),
                        ),

                      ),
                    ),
                  ),
                ),



                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        //print("Successful");
                        //SignIn();
                        //Navigator.push(context, MaterialPageRoute(builder: (context) =>SignupPage()));
                        DbHelper dbHelper = DbHelper();
                        dbHelper.addData(amount!, selectedDate, type, note);
                        Navigator.pop(context);
                      } else {
                        print("Something wrong");
                      }

                      print(amount);
                      print(note);
                      print(type);
                      print(selectedDate);
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.amber
                      ),

                      child: Center(child: Text("Add Trancaction",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }
}
