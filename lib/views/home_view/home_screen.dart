import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _cardNumber = 'Tap your card to scan';
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
      } else {
        setState(() {
          _cardNumber = 'NDEF not available';
        });
      }
    } catch (e) {
      setState(() {
        _cardNumber = 'Error: $e';
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
                          SnackBar(content: Text('Please enter a number')),
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
