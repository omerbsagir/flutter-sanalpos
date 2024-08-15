import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:flutterprojects/viewmodels/wallet_viewmodel.dart';
import 'package:flutterprojects/viewmodels/payment_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../../data/remote/response/api_response.dart';
import '/views/widgets/custom_scaffold.dart';

class MyWalletScreen extends StatefulWidget {
  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {

  final UserViewModel userViewModel = UserViewModel();
  final WalletViewModel walletViewModel = WalletViewModel();
  final PaymentViewModel paymentViewModel = PaymentViewModel();

  @override
  void initState() {
    super.initState();
    _loadTransactionsData();
    _loadWalletData();
  }

  Future<void> _loadTransactionsData() async {
    final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
    paymentViewModel.TransactionDetails.clear();
    await paymentViewModel.getTransactions();
  }

  Future<void> _loadWalletData() async {
    final walletViewModel = Provider.of<WalletViewModel>(context, listen: false);
    walletViewModel.walletDetails.clear();
    await walletViewModel.updateWallet();
    await walletViewModel.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    final walletViewModel = Provider.of<WalletViewModel>(context);

    return CustomScaffold(
      title: 'My Wallet',
      actions: [
        IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () {
            HapticFeedback.heavyImpact();
            _loadWalletData();
            _loadTransactionsData();
          },
        ),
      ],
      body: Center(
        child: Column(
          children: [
            if (!walletViewModel.isWalletLoaded) ...[
              SizedBox(height: 25),
              Text(
                'Your Company Does Not Have Wallet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ] else ...[
              Consumer<WalletViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.walletResponse.status == Status.LOADING) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildCreditCard('', '0'),
                      ],
                    );
                  } else if (viewModel.walletResponse.status == Status.COMPLETED) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (viewModel.walletDetails.isNotEmpty) ...[
                          _buildCreditCard(viewModel.walletDetails[0], viewModel.walletDetails[1]),
                        ] else ...[
                          Text('No wallet details available.', style: TextStyle(color: Colors.grey)),
                        ],
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'An error occurred.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              ),
              Consumer<PaymentViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.paymentResponse.status == Status.LOADING) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ExpansionTile(
                        title: Center(
                          child: Text(
                            'View Transactions',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        initiallyExpanded: false,
                        children: [
                          // Wrap the list of transactions with SingleChildScrollView
                          Container(
                            height: 450, // Adjust the height as needed
                          ),
                        ],
                      ),
                    );
                  } else if (viewModel.paymentResponse.status == Status.COMPLETED) {
                    final transactionDetails = viewModel.TransactionDetails;

                    // Sort transactions to show the most recent first
                    transactionDetails.sort((a, b) => b.date.compareTo(a.date));

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ExpansionTile(
                        title: Center(
                          child: Text(
                            'View Transactions',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        initiallyExpanded: true,
                        children: [
                          // Wrap the list of transactions with SingleChildScrollView
                          Container(
                            height: 450, // Adjust the height as needed
                            child: SingleChildScrollView(
                              child: Column(
                                children: transactionDetails.isNotEmpty
                                    ? transactionDetails.map<Widget>((transaction) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10 ),
                                          child: Icon(
                                            Icons.fiber_manual_record,
                                            color: Colors.grey,
                                            size: 8,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                              Center(
                                                child: Text(
                                                  '+${formatNumberWithDots(transaction.amount)},00 TL',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.lightGreen
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4.0),
                                              Center(
                                                child: Text(
                                                  '${transaction.date}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList()
                                    : [Center(child: Text('No transactions available.', style: TextStyle(color: Colors.grey)))],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'An error occurred.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
              )

            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard(String iban, String balance) {
    return Container(
      height: 185,
      width: 370,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.green, Colors.deepPurpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IBAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            iban,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'BALANCE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${formatNumberWithDots(balance)},00 TL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  String formatNumberWithDots(String number) {
    final numberFormat = NumberFormat('#,##0', 'en_US');
    final formattedNumber = numberFormat.format(double.tryParse(number) ?? 0);
    return formattedNumber.replaceAll(',', '.');
  }
}
