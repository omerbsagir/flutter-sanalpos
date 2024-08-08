import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _cardNumber = 'Tap your card to scan';

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
            Text(_cardNumber),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanNFC,
              child: Text('Scan NFC Card'),
            ),
          ],
        ),
      ),
    );
  }
}

