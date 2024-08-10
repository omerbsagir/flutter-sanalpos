import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _input = '';
  String tlText = '';
  bool _showNFCScan = false;

  void _onButtonPressed(String value) {
    setState(() {
      _input += value;
      tlText= ' TL';
    });
  }

  void _onClearPressed() {
    setState(() {
      _input = '';
      tlText= '';
    });
  }

  Future<void> _scanNFC() async {
    try {
      final nfctag = await FlutterNfcKit.poll();
      if (nfctag.ndefAvailable != null && nfctag.ndefAvailable!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'NFC Tarama İşlemi Başarılı',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
        );
        _input = '';
        tlText = '';

      } else {
        setState(() {
          _input = '';
          tlText = '';
          _showNFCScan = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'NFC Tarama İşlemi Başarısız',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _input = '';
        tlText = '';
        _showNFCScan = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'NFC Tarama İşlemi Başarısız',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
      );
    } finally {
      await FlutterNfcKit.finish();
    }
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
                        if (_input.isNotEmpty) {
                          setState(() {
                            _showNFCScan = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                child: Text(
                                  'Lütfen Geçerli Bir Sayı Girin!',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                            ),
                          );
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
