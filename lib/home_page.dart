import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_expense_manager/add_transaction_page.dart';
import 'package:hive_expense_manager/db_helper.dart';
import 'package:hive_expense_manager/models/transaction_model.dart';
import 'package:hive_expense_manager/widgets/confirm_dialog.dart';
import 'package:hive_expense_manager/widgets/info_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //
  late Box box;
  late SharedPreferences preferences;
  DbHelper dbHelper = DbHelper();
  Map? data;
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpense = 0;
  List<FlSpot> dataSet = [];
  DateTime today = DateTime.now();
  DateTime now = DateTime.now();
  int index = 1;

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

  @override
  void initState() {
    super.initState();
    getPreference();
    box = Hive.box('money');
  }

  getPreference() async {
    preferences = await SharedPreferences.getInstance();
  }





  List<FlSpot> getPlotPoints(Map entireData){
    dataSet = [];
    entireData.forEach((key, value) {
      if(value["type"] == "Expense" && (value["date"] as DateTime).month == today.month){
        dataSet.add(FlSpot((value["date"] as DateTime).day.toDouble(), (value["amount"] as int).toDouble(),),);
      }
    });
    return dataSet;
  }






  getTotalBalance(Map entireData){
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    entireData.forEach((key, value) {
      print(value);
      if(value["type"] == "Income"){
        totalBalance +=  (value["amount"] as int);
        totalIncome +=  (value["amount"] as int);
      }else{
        totalBalance -=  (value["amount"] as int);
        totalExpense +=  (value["amount"] as int);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.person),
          ),
        ),

        //title: Text("Welcome ${preferences.getString("name")}",style: TextStyle(color: Colors.black),),
        title: Text("Welcome Shahriar",style: TextStyle(color: Colors.black),),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  12.0,
                ),
                color: Colors.amber,
              ),
              padding: EdgeInsets.all(
                6.0,
              ),
              child: InkWell(
                onTap: () {
                  /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settings(),),).then((value) {
                                setState(() {});
                              });*/
                },
                child: Icon(
                  Icons.settings,
                  size: 32.0,
                  color: Color(0xff3E454C),
                ),
              ),
            ),
          ),
        ],

      ),



      /*appBar: AppBar(
        toolbarHeight: 0.0,
      ),*/





      //backgroundColor: Colors.grey[200],
      //
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            CupertinoPageRoute(
              builder: (context) => AddTransactionPage(),
            ),
          )
              .then((value) {
            setState(() {});
          });
        },
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16.0,
          ),
        ),*/
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add_outlined,
          size: 32.0,
          color: Colors.amber,
        ),
      ),
      //
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(
                  12.0,
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.amber,
                        Colors.amberAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        24.0,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          24.0,
                        ),
                      ),
                      // color: Static.PrimaryColor,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 18.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            // fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          'Tk $totalBalance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardIncome(
                                totalIncome.toString(),
                              ),
                              cardExpense(
                                totalExpense.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),





              Container(
                height: 550,
                child: FutureBuilder<Map>(
                  future : dbHelper.fetch(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      return Center(child: Text("Unexpected Error!"));
                    }if(snapshot.hasData){
                      if(snapshot.data!.isEmpty){
                        return Center(child: Text("No Values Found!"));
                      }

                      getTotalBalance(snapshot.data!);
                      getPlotPoints(snapshot.data!);


                      return ListView(
                        padding: const EdgeInsets.all(8),
                        children: [


                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Expenses Chart",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
                          ),
                          
                          
                          
                          //Chart
                          dataSet.length<2? Container(
                            //height: 400,
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 40),
                            margin : EdgeInsets.all(12),
                            decoration :BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Text("Not Enough Values to render Chart"),
                          )
                              :Container(
                            height: 400,
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 40),
                            margin : EdgeInsets.all(12),
                            decoration :BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 6,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),

                            child: LineChart(
                                LineChartData(
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: getPlotPoints(snapshot.data!) ,
                                      isCurved: false,
                                      barWidth: 2.5,
                                      color: Colors.amber,
                                    ),
                                  ],
                                )
                            ),
                          ),
                          

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Recent Expenses",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
                          ),

                          ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                Map dataAtIndex = snapshot.data![index];
                                //Text("data",style: TextStyle(color: Colors.black),);
                                if(dataAtIndex["type"] == "Income"){
                                  return incomeTile(dataAtIndex["amount"], dataAtIndex["note"]);
                                }else{
                                  return expenseTile(dataAtIndex["amount"], dataAtIndex["note"]);
                                }

                              },
                          ),
                        ],
                      );
                    }else{
                      return Center(child: Text("Unexpected Error!"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //



  //
//
//
// Widget
//
//

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value) {
    return Row(
      children: [
        Container(
          //margin: EdgeInsets.all(8),
          //padding: EdgeInsets.all(8),

          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value,String note){
    return Container(
      //height: 100,
      //width: double.infinity,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_circle_down_outlined,size: 28,color: Colors.red,),
              SizedBox(width: 4,),
              Text("Expense"),
            ],
          ),


          Text("- $value",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }




  Widget incomeTile(int value,String note){
    return Container(
      //height: 100,
      //width: double.infinity,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_circle_up_outlined,size: 28,color: Colors.green,),
              SizedBox(width: 4,),
              Text("Income"),
            ],
          ),


          Text("+ $value",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
        ],
      ),
    );
  }




  Widget selectMonth() {
    return Padding(
      padding: EdgeInsets.all(
        8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                index = 3;
                today = DateTime(now.year, now.month - 2, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 3 ? Colors.white : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 3],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 3 ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 2;
                today = DateTime(now.year, now.month - 1, today.day);
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 2 ? Colors.white : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 2],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 2 ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                index = 1;
                today = DateTime.now();
              });
            },
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
                color: index == 1 ? Colors.white : Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                months[now.month - 1],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: index == 1 ? Colors.white : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  ///


}