import 'package:avas_transfer/constants.dart';
import 'package:avas_transfer/models/contacts_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsDialog extends StatelessWidget {
  final ContactsModel _contacts;

  ContactsDialog(this._contacts);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        physics: BouncingScrollPhysics(),
        itemCount: _contacts.payload.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, _contacts.payload[index]);
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: appColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _contacts.payload[index].alias[0],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _contacts.payload[index].alias,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          _contacts.payload[index].account,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 1,
            color: Colors.grey.shade200,
          );
        },
      ),
    );
  }
}
