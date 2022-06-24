import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPercentOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, Constraints) {
        return Column(children: <Widget>[
          Container(
            height: Constraints.maxHeight*0.14,
            child: FittedBox(
              child: Text('${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          SizedBox(height: Constraints.maxHeight*0.05),
          Container(
              height: Constraints.maxHeight*0.55,
              width: 15,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                      heightFactor: spendingPercentOfTotal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ],
              )),
          SizedBox(height: Constraints.maxHeight*0.10),
          Container(
            height: Constraints.maxHeight*0.15,
            child: FittedBox(
              child: Text(label)),
          ),
        ]);
      },
    );
  }
}
