import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((context, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(height: constraints.maxHeight*0.1),
                Text('No Transactions added yet!',
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.normal,
                      fontSize: 20, 
                    )),
                SizedBox(height: constraints.maxHeight*0.1),
                Container(
                  height: constraints.maxHeight * 0.35,
                  child: MediaQuery.of(context).orientation== Orientation.portrait ?
                   Image.asset(
                    'lib/images/img.jpg',
                    fit: BoxFit.cover,
                  )
                  : SizedBox(height: constraints.maxHeight*0.1,)
                ),
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                color: Color.fromARGB(239, 255, 255, 255),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    /*  side: new BorderSide(
                          color: Color.fromARGB(255, 21, 255, 243), width: 3.0),*/
                    borderRadius: BorderRadius.circular(25)),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                          child: Text('${transactions[index].amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))),
                    ),
                  ),
                  title: Text(transactions[index].title,
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Text(
                    DateFormat.yMMMd().format(
                      transactions[index].date,
                    ),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400 ?
                  FlatButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transactions[index].id),
                    )
                   : IconButton(
                    icon: Icon(Icons.delete_sweep),
                    color: Theme.of(context).errorColor,
                    onPressed: () => deleteTx(transactions[index].id),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
