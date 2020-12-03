import 'package:avas_transfer/models/transfer_confirm_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Receipt extends StatefulWidget {
  final TransferConfirmModel receipt;

  Receipt(this.receipt);

  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  final template = DateFormat('d/M/yyyy H:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
        ),
      ]),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: Color(0xfffefefe),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Transaction Receipt',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status'),
                Text(
                  'SUCCESS',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Message'),
                SizedBox(
                  width: 30,
                ),
                Flexible(
                  child: Text(
                    'Transfer transaction is successful.',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ref #'),
                Text(
                  widget.receipt.payload.reference,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date'),
                Text(
                  template.format(DateTime.parse(widget.receipt.payload.timestamp.split('+')[0])),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('From'),
                Text(
                  widget.receipt.payload.from.name,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('To'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.receipt.payload.to.name,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      widget.receipt.payload.to.account,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount'),
                Text(
                  '${widget.receipt.payload.currency} ${widget.receipt.payload.debitamount}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.receipt.payload.remarks.isNotEmpty,
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remarks'),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                        child: Text(
                          widget.receipt.payload.remarks,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: Image.asset('assets/bml_logo.png'),
            ),
          ],
        ),
      ),
    );
  }
}
