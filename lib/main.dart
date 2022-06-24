import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        errorColor: Color.fromARGB(255, 165, 109, 105),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Color.fromARGB(221, 8, 8, 8),
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTranscation(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTranscation);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS ? 
    CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
       
          GestureDetector(
             child: Icon(CupertinoIcons.add),
            onTap:  () => _startAddNewTransaction(context))
      ],),
    ) : AppBar(
      title: Text(
        'Expenses Tracker',
        style: TextStyle(color: Colors.white, shadows: [
          Shadow(
            blurRadius: 20.0,
            color: Colors.grey[600],
            offset: Offset(5.0, 5.0),
          )
        ]),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              Colors.blue[600],
              Colors.blue[700],
              Colors.blue[800],
              Colors.blue[900],
            ],
          ),
        ),
      ),
      actions: <Widget>[
          IconButton(
              onPressed: () => _startAddNewTransaction(context),
              icon: Icon(Icons.add)),],
        
    );

    final txListWidget = Container(
      padding: EdgeInsets.all(10),
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.55,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );



    final pageBody = SafeArea(child:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (isLandscape)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
        Text('Show Chart', style: Theme.of(context).textTheme.titleMedium,),
                        Switch.adaptive(
                          activeColor: Theme.of(context).accentColor,
                          value: _showChart,
                          onChanged: (val) {
                            setState(() {
                              _showChart = val;
                            });
                          },
                        ),
                      ],
                    ),

                  if (!isLandscape)
                    Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.3,
                        child: Chart(_recentTransactions)),

                  //if(!isLandscape) txListWidget,

                  if (isLandscape)
                    _showChart
                        ? Container(
                            height: (mediaQuery.size.height -
                                    appBar.preferredSize.height -
                                    mediaQuery.padding.top) *
                                0.8,
                            child: Chart(_recentTransactions))
                        : SizedBox(height: mediaQuery.size.height * 0.05),
                  txListWidget
                ],
              ),
            ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar,)
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS ? Container()
            : FloatingActionButton  (
              child: Container(
                alignment: Alignment.center,
                child: Icon(Icons.add),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    gradient: LinearGradient(
                        colors: [Color(0xff43cea2), Color(0xff5a918d)]),
                    shape: BoxShape.circle),
              ),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
