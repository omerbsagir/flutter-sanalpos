import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _numberController = TextEditingController();
  bool _showNFCScan = false;

  Future<void> _scanNFC() async {
    try {
      final nfctag = await FlutterNfcKit.poll();
      if (nfctag.ndefAvailable != null && nfctag.ndefAvailable!) {
        final ndefRecords = await FlutterNfcKit.readNDEFRecords();
        setState(() {
          _cardNumber = ndefRecords.map((r) => r.payload).join(', ');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'NFC Tarama İşlemi Başarılı',
                style: TextStyle(color: Colors.white), // Yazı rengi
                textAlign: TextAlign.center, // Yazıyı ortalar
              ),
            ),
            backgroundColor: Colors.green, // Arka plan rengi
            behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ), // Yuvarlak köşe
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
          ),
        );
        _numberController.clear();
      } else {
        setState(() {
          _cardNumber = 'NDEF not available';
          _numberController.clear();
          _showNFCScan = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  'NFC Tarama İşlemi Başarısız',
                  style: TextStyle(color: Colors.white), // Yazı rengi
                  textAlign: TextAlign.center, // Yazıyı ortalar
                ),
              ),
              backgroundColor: Colors.red, // Arka plan rengi
              behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ), // Yuvarlak köşe
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
            ),
          );
        });

      }
    } catch (e) {
      setState(() {
        _numberController.clear();
        _showNFCScan = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'NFC Tarama İşlemi Başarısız',
                style: TextStyle(color: Colors.white), // Yazı rengi
                textAlign: TextAlign.center, // Yazıyı ortalar
              ),
            ),
            backgroundColor: Colors.red, // Arka plan rengi
            behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ), // Yuvarlak köşe
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
          ),
        );
      });
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Home / NFC",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showNFCScan)
              Column(
                children: [
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter a number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_numberController.text.isNotEmpty) {
                        setState(() {
                          _showNFCScan = true;
                        });
                      } else {
                        // Show an alert or a message if the input is empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                'Lütfen Geçerli Bir Sayı Girin !',
                                style: TextStyle(color: Colors.white), // Yazı rengi
                                textAlign: TextAlign.center, // Yazıyı ortalar
                              ),
                            ),
                            backgroundColor: Colors.orange, // Arka plan rengi
                            behavior: SnackBarBehavior.floating, // Snackbar'ın ekranın biraz yukarısında görüntülenmesi için
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ), // Yuvarlak köşe
                            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Kenarlardan uzaklık
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    child: Text(
                      "Proceed to NFC Scan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _cardNumber,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
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
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
