import 'package:avas_transfer/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountsDialog extends StatelessWidget {
  final accounts = dashboardModel.payload.dashboard
      .where((element) => element.accountType == 'CASA')
      .toList();

  var formatter = new NumberFormat.currency(locale: "en_US", symbol: "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).pop(accounts[index].id);
            },
            title: Text(accounts[index].account, style: TextStyle(
              color: Colors.black38,
              fontSize: 16,
            ),),
            trailing: Text(
              '${accounts[index].currency} ${formatter.format(accounts[index].availableBalance)}',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 1,
          );
        },
        itemCount: accounts.length,
      ),
    );
  }
}
