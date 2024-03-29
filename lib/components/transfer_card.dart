import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:avas_transfer/components/accounts_dialog.dart';
import 'package:avas_transfer/components/contacts_dialog.dart';
import 'package:avas_transfer/components/message_dialog.dart';
import 'package:avas_transfer/models/account_validate_model.dart';
import 'package:avas_transfer/models/contacts_model.dart' as contact;
import 'package:avas_transfer/models/dashboard_model.dart';
import 'package:avas_transfer/models/transfer_confirm_model.dart';
import 'package:avas_transfer/models/transfer_review_model.dart';
import 'package:avas_transfer/screens/login_screen.dart';
import 'package:avas_transfer/services/api.dart' as api;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:sms/sms.dart';

import '../constants.dart';
import '../global.dart';
import 'circular_indicator.dart';
import 'receipt.dart';

class TransferCard extends StatefulWidget {
  TransferCard();

  @override
  _TransferCardState createState() => _TransferCardState();
}

class _TransferCardState extends State<TransferCard> {
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final GlobalKey _receiptKey = new GlobalKey();
  TransferConfirmModel receipt;

  final FocusNode _amountFocusNode = FocusNode();
  Dashboard account;

  bool verifying = false;
  String validateAccountString = '';
  Color validateAccountStringColor = Colors.grey.shade700;
  int state = 0;
  String receiptFile = "";
  //var formatter = NumberFormat('#,###.##');
  var formatter = new NumberFormat.currency(locale: "en_US", symbol: "");

  _validateAccount(contact.Payload c) async {
    FocusScope.of(context).unfocus();

    if (verifying) return;

    setState(() {
      verifying = true;
    });

    var res = await api.get(
      context,
      'validate/account/${_accountNumberController.text.trim()}',
    );

    setState(() {
      verifying = false;
    });

    debugPrint(res.body.toString());

    if (res.statusCode == 200) {
      AccountValidateModel model =
          AccountValidateModel.fromJson(json.decode(res.body));
      if (model.success) {
        debugPrint('success');
        setState(() {
          validateAccountStringColor = Colors.grey.shade700;
          validateAccountString = c == null
              ? '${model.payload.name.toUpperCase()} (${model.payload.currency})'
              : '${c.alias} (${c.currency})';
        });
        _amountFocusNode.requestFocus();
      } else {
        setState(() {
          validateAccountStringColor = appColor;
          validateAccountString = model.code == 38
              ? model.message.toUpperCase()
              : 'INVALID ACCOUNT NUMBER';
        });
        debugPrint('failed');
      }
    } else {
      // error
    }
  }

  _transferReview() async {
    FocusScope.of(context).unfocus();

    if (verifying) return;

    setState(() {
      verifying = true;
    });

    final box = GetStorage();

    var res = await api.post(
      context,
      'transfer',
      body: {
        'transfertype': 'IAT',
        'channel': 'mobile',
        'currency': 'MVR',
        'debitAccount': box.read('accountId'),
        'debitAmount': _amountController.text.trim(),
        'creditAccount': _accountNumberController.text.trim(),
      },
    );

    setState(() {
      verifying = false;
    });

    debugPrint(res.body);
    TransferReviewModel model =
        TransferReviewModel.fromJson(json.decode(res.body));
    if (model.success) {
      setState(() {
        state = 1;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => MessageDialog(model.message),
      );

      setState(() {
        state = 0;
      });
    }
  }

  _transferConfirm() async {
    FocusScope.of(context).unfocus();

    if (verifying) return;

    setState(() {
      verifying = true;
    });

    final box = GetStorage();
    var res = await api.post(
      context,
      'transfer',
      body: {
        'transfertype': 'IAT',
        'channel': 'mobile',
        'currency': 'MVR',
        'narrative2': '',
        'm_ref': '',
        'additionalInstruction': '',
        'debitAccount': box.read('accountId'),
        'debitAmount': _amountController.text.trim(),
        'creditAccount': _accountNumberController.text.trim(),
        'remarks': _remarksController.text.trim(),
        'otp': _otpController.text.trim(),
      },
    );

    _otpController.clear();
    validateAccountString = '';

    TransferConfirmModel model =
        TransferConfirmModel.fromJson(json.decode(res.body));
    if (model.success) {
      _accountNumberController.clear();
      _amountController.clear();
      _remarksController.clear();

      receipt = model;
      setState(() {
        verifying = false;
        state = 2;
      });

      var res = await api.get(context, 'dashboard');
      final box = GetStorage();
      setState(() {
        dashboardModel = DashboardModel.fromJson(json.decode(res.body));
        account = dashboardModel.payload.dashboard
            .firstWhere((element) => element.id == box.read('accountId'));
      });
      await _saveReceipt();
    } else {
      showDialog(
        context: context,
        builder: (_) => MessageDialog(model.message),
      );

      setState(() {
        verifying = false;
        state = 0;
      });
    }
  }

  showCameraDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Wrap(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      _scanBarcode();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 35,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'QR',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: FlatButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      // _read();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 35,
                          color: Colors.grey.shade600,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'OCR',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _scanBarcode() async {
    // String res = await FlutterBarcodeScanner.scanBarcode(
    //   '#D60D25',
    //   'Cancel',
    //   false,
    //   ScanMode.QR,
    // );
    //
    // // 13 is the normal account length
    // if (res.length >= 10) {
    //   _accountNumberController.text = res;
    //   _validateAccount(null);
    // }
  }

  // Future<Null> _read() async {
  //   List<OcrText> texts = [];
  //   try {
  //     texts = await FlutterMobileVision.read(
  //       camera: FlutterMobileVision.CAMERA_BACK,
  //       waitTap: true,
  //     );
  //
  //     debugPrint('total read: ${texts[0].value}');
  //     debugPrint('total read: ${texts.length}');
  //     for (OcrText text in texts) {
  //       debugPrint('Scan Data: ${text.value}');
  //       if (text.value.startsWith('7') && text.value.length == 13) {
  //         _accountNumberController.text = text.value;
  //         _validateAccount(null);
  //       }
  //     }
  //   } on Exception {
  //     // Unable to read text
  //   }
  // }

  _reviewBody() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();

            var res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AccountsDialog();
                });

            if (res != null) {
              final box = GetStorage();
              box.write('accountId', res);
              setState(() {
                account = dashboardModel.payload.dashboard.firstWhere(
                    (element) => element.id == box.read('accountId'));
              });
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.07),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.account,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black26,
                  ),
                ),
                Text(
                  '${account.currency} ${formatter.format(account.availableBalance)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: account.availableBalance > 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          textAlign: TextAlign.center,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.number,
          maxLength: 13,
          autofocus: false,
          controller: _accountNumberController,
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Account Number',
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            counterText: '',
            prefixIcon: IconButton(
              onPressed: () async {
                //showCameraDialog();
                _scanBarcode();
              },
              icon: Icon(Icons.camera_alt_outlined),
            ),
            suffixIcon: IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => ContactsDialog(contactsModel),
                ).then((value) {
                  if (value != null) {
                    contact.Payload c = value;
                    _accountNumberController.text = c.account;
                    _validateAccount(value);
                  }
                });
              },
              icon: Icon(Icons.person),
            ),
          ),
          onChanged: (val) {
            if (val.length == 13) {
              _validateAccount(null);
            } else {
              setState(() {
                validateAccountString = '';
              });
            }
          },
          onSubmitted: (val) {},
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Visibility(
          visible: validateAccountString.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              validateAccountString,
              style: TextStyle(
                color: validateAccountStringColor,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          textAlign: TextAlign.center,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          maxLength: 8,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: '0.00',
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            counterText: '',
          ),
          keyboardAppearance: Brightness.light,
          controller: _amountController,
          focusNode: _amountFocusNode,
          onSubmitted: (val) {},
          style: TextStyle(
            fontSize: 30,
            color: Colors.green,
            letterSpacing: 1.7,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          enableSuggestions: true,
          autocorrect: true,
          minLines: 3,
          maxLines: 5,
          controller: _remarksController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Remarks',
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            counterText: '',
          ),
          keyboardAppearance: Brightness.light,
          onSubmitted: (val) {},
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  _confirmBody() {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.number,
          maxLength: 6,
          controller: _otpController,
          keyboardAppearance: Brightness.light,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: '000000',
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            counterText: '',
          ),
          onSubmitted: (val) {},
          style: TextStyle(
            fontSize: 30,
            letterSpacing: 10,
          ),
        ),
      ],
    );
  }

  _receiptBody() {
    return RepaintBoundary(
      key: _receiptKey,
      child: Receipt(receipt),
    );
  }

  _getBody() {
    switch (state) {
      case 0:
        return _reviewBody();
        break;
      case 1:
        return _confirmBody();
        break;
      case 2:
        return _receiptBody();
        break;
    }
  }

  _createAppDirectory() async {
    String dirPath = await _getExternalStoragePath();
    debugPrint(dirPath);
    final myDir = Directory(dirPath);
    myDir.exists().then((isThere) async {
      if (isThere) {
        print('dir exists');
      } else {
        print('creating dir...');

        Directory(dirPath).create(recursive: true).then(
          (Directory directory) {
            print('directory created');
          },
        );
      }
    });
  }

  _getExternalStoragePath() async {
    Directory directory;
    String path = "";

    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
      List<String> folders = directory.path.split("/");
      for (int i = 1; i < folders.length; i++) {
        String folder = folders[i];
        if (folder != "Android")
          path += "/$folder";
        else
          break;
      }
      path += "/BML Avas Transfer";
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
      path = directory.path;
    }

    return path;
  }

  _saveReceipt() async {
    RenderRepaintBoundary boundary =
        _receiptKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    String dirPath = await _getExternalStoragePath();
    var filename = DateTime.now().millisecondsSinceEpoch;
    var path = '$dirPath/$filename.png';
    File(path).writeAsBytesSync(pngBytes.buffer.asInt8List());

    receiptFile = path;
  }

  _shareReceipt() async {
    try {
      await _createAppDirectory();

      if (receiptFile.isEmpty) await _saveReceipt();

      await ShareExtend.share(receiptFile, "image");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    final box = GetStorage();
    account = dashboardModel.payload.dashboard
        .firstWhere((element) => element.id == box.read('accountId'));

    super.initState();
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) {
      if (msg.sender.contains('455')) {
        try {
          String otp = msg.body.split('.')[0];
          otp = otp.substring(otp.length - 6);
          _otpController.text = otp;
        } catch (Exception) {
          debugPrint('error reading otp code from sms');
        }
      }
      debugPrint(msg.sender);
      debugPrint(msg.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
      child: GestureDetector(
        onLongPress: () async {
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Are you sure to sign out?'),
                  actions: [
                    CupertinoButton(
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    CupertinoButton(
                        child: Text(
                          'Yes',
                          style: TextStyle(color: appColor),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          final box = GetStorage();
                          await box.erase();
                          // await SharedPreferences.clear();

                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        }),
                  ],
                );
              });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: Image.asset('assets/logo.png'),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    Text(
                      'AVAS',
                      style: TextStyle(
                        color: appColor,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'TRANSFER',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        letterSpacing: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            _getBody(),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: state == 1 || state == 2,
                  child: Expanded(
                    child: SizedBox(
                      height: 55,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        highlightedBorderColor: Colors.grey.shade500,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.grey.shade500.withOpacity(0.1),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                          width: 1.5,
                        ),
                        onPressed: () async {
                          if (state == 2 && receiptFile.isEmpty)
                            await _saveReceipt();

                          setState(() {
                            _otpController.clear();
                            receiptFile = "";
                            state = 0;
                          });
                        },
                        child: Text(
                          state == 1 ? 'Cancel' : 'Close',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            letterSpacing: 1.2,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: state != 0,
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlineButton(
                      // color: state == 2 ? Colors.grey.shade500 : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      highlightedBorderColor: Colors.green.shade500,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.green.shade500.withOpacity(0.1),
                      borderSide: BorderSide(
                        color: Colors.green.shade500,
                        width: 1.5,
                      ),
                      onPressed: () async {
                        if (state == 0)
                          _transferReview();
                        else if (state == 1)
                          _transferConfirm();
                        else if (state == 2) {
                          _shareReceipt();
                        }
                      },
                      child: verifying
                          ? CircularIndicator(
                              color: Colors.green.shade500,
                            )
                          : Text(
                              state == 0
                                  ? 'Transfer'
                                  : state == 1
                                      ? 'Confirm'
                                      : 'Share',
                              style: TextStyle(
                                color: Colors.green.shade500,
                                letterSpacing: 1.2,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
