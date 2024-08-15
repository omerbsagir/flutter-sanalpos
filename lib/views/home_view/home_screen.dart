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
  bool _showNFCScan = false;
  bool activationStatus = false;


  void _onButtonPressed(String value) {
    HapticFeedback.heavyImpact();
    setState(() {

      if((_input+value).length <= 5){
        _input += value;
        tlText= ' TL';
      }else{
        CustomSnackbar.show(context,'Maksimum miktar 99.999 TL',Colors.orange);
      }
    });
  }

  void _onClearPressed() {
    HapticFeedback.heavyImpact();
    setState(() {
      _input = '';
      tlText= '';
    });
  }

  Future<void> _scanNFC() async {
    final PaymentViewModel paymentViewModel = Provider.of<PaymentViewModel>(context,listen:false);

    try {
      final nfctag = await FlutterNfcKit.poll();
      if (nfctag.ndefAvailable != null && nfctag.ndefAvailable!) {
        CustomSnackbar.show(context,'NFC Tarama İşlemi Başarılı',Colors.green);

        try{
          await paymentViewModel.createTransactions(_input.toString());
          CustomSnackbar.show(context, 'Ödeme Başarıyla Alındı', Colors.greenAccent);
        }catch(e){
          print(e);
        }

        _input = '';
        tlText = '';

      } else {
        setState(() {
          _input = '';
          tlText = '';
          _showNFCScan = false;
        });
        CustomSnackbar.show(context,'NFC Tarama İşlemi Başarısız',Colors.red);
      }

    } catch (e) {
      setState(() {
        _input = '';
        tlText = '';
        _showNFCScan = false;
      });
      CustomSnackbar.show(context,'NFC Tarama İşlemi Başarısız',Colors.red);
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadActivationStatus();
  }
  Future<void> _loadActivationStatus() async {
    final companyAndActivationViewModel = Provider.of<CompanyAndActivationViewModel>(context, listen: false);

    await companyAndActivationViewModel.checkActiveStatus();
    activationStatus = companyAndActivationViewModel.isActive;

  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Home / NFC",
      body: Center(
        child: _showNFCScan
            ? ElevatedButton(
          onPressed: _scanNFC,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
          ),
          child: Text(
            "Scan NFC Card",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20.0),
                child: Text(
                  _input + tlText,
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
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
                          setState(() {
                            _showNFCScan = true;
                          });
                        } else {
                          if(activationStatus == true){
                            CustomSnackbar.show(context,'Lütfen Geçerli Bir Sayı Girin',Colors.orange);
                          }else{
                            CustomSnackbar.show(context,'Şirketiniz Aktif Durumda Değil',Colors.orange);
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
          ],
        ),
      ),
    );
  }
}
