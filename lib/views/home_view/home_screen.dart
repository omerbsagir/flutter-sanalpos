import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/company_and_activation_viewmodel.dart';
import '../../viewmodels/payment_viewmodel.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:vibration/vibration.dart';
import '../widgets/custom_snackbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _input = '';
  String tlText = '';
  bool activationStatus = false;

  void _onButtonPressed(String value) {
    HapticFeedback.heavyImpact();
    setState(() {
      if ((_input + value).length <= 5) {
        _input += value;
        tlText = ' TL';
      } else {
        CustomSnackbar.show(
            context, 'Maksimum miktar 99.999 TL', Colors.orange);
      }
    });
  }

  void _onClearPressed() {
    HapticFeedback.heavyImpact();
    setState(() {
      _input = '';
      tlText = '';
    });
  }

  void _showAmountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: Container(

            child : AlertDialog(
              title: Text('İşlem Yapılacak Miktar',style : TextStyle(fontSize: 25,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _input + tlText,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _scanNFC();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Taramayı Başlat',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      _resetInput();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    ),
                    child: Text(
                      'Geri',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

        );

      },
    );
  }


  Future<void> _scanNFC() async {
    final PaymentViewModel paymentViewModel =
    Provider.of<PaymentViewModel>(context, listen: false);



    try {
      final nfctag = await Future.any([
        FlutterNfcKit.poll(),
      ]);

       if (nfctag.ndefAvailable != null && nfctag.ndefAvailable!) {
        CustomSnackbar.show(context, 'NFC Tarama İşlemi Başarılı', Colors.green);
        _showBottomSheet();

        try {
          await paymentViewModel.createTransactions(_input.toString());
          Navigator.pop(context);
          CustomSnackbar.show(context, 'Ödeme Başarıyla Alındı', Colors.greenAccent);
        } catch (e) {
          print(e);
          CustomSnackbar.show(context, 'Ödeme İşlemi Başarısız', Colors.red);
        }

        // NFC taraması başarılı olunca giriş alanını sıfırla
        _resetInput();
      } else {
        _resetInput();
        CustomSnackbar.show(context, 'NFC Tarama İşlemi Başarısız', Colors.red);
      }


    } on TimeoutException catch (_) {
      _resetInput();
      CustomSnackbar.show(context, 'NFC tarama süresi doldu', Colors.red);
    } catch (e) {
      _resetInput();
      CustomSnackbar.show(context, 'NFC Tarama İşlemi Başarısız', Colors.red);
    } finally {
      await FlutterNfcKit.finish();
    }
  }


  void _resetInput() {
    setState(() {
      _input = '';
      tlText = '';

    });
  }

  @override
  void initState() {
    super.initState();
    _loadActivationStatus();
  }

  Future<void> _loadActivationStatus() async {
    final companyAndActivationViewModel =
    Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    await companyAndActivationViewModel.checkActiveStatus();
    activationStatus = companyAndActivationViewModel.isActive;
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 20, 5, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjusted to fit content
              children: [
                Image.asset(
                  'assets/nfc_scan.png', // Replace with your own image asset
                  height: 250, // Increased image size
                ),
                SizedBox(height: 30), // Increased spacing
                Text(
                    'NFC taranmaya hazır, kartınızı cihazınıza yaklaştırın',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500), // Increased font size and weight
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30), // Increased spacing
                ElevatedButton(
                  onPressed: () {
                    _resetInput();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Cancel', style: TextStyle(fontSize: 20,color:Colors.white)), // Increased font size
                ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    ).whenComplete(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Ana Sayfa / NFC",
      body: Center(
          child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black12,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(20.0),
                child:
                Text(
                  _input + tlText,
                  style: TextStyle(
                    fontSize: 80,
                    color: Colors.black87,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0
                  ),
                ),
              ),
            ),
            Divider(thickness: 2,color: Colors.grey,height: 0,),
            SizedBox(height: 20,),
            Expanded(
              flex: 9,
              child: Container(
                color: Colors.white12,
                child: GridView.builder(
                  padding: EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return ElevatedButton(
                        onPressed: _onClearPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: SizedBox.shrink(),
                      );
                    } else if (index == 11) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_input.isNotEmpty && activationStatus != false) {
                            HapticFeedback.heavyImpact();
                            _showAmountDialog();
                          } else {
                            if (activationStatus == true) {
                              CustomSnackbar.show(context,
                                  'Lütfen Geçerli Bir Sayı Girin', Colors.orange);
                            } else {
                              CustomSnackbar.show(context,
                                  'Şirketiniz Aktif Durumda Değil', Colors.orange);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        child: SizedBox.shrink(),
                      );
                    } else if (index == 10) {
                      return ElevatedButton(
                        onPressed: () => _onButtonPressed('0'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                        child: Text(
                          '0',
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () => _onButtonPressed('${index + 1}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
