import 'package:flutter/material.dart';
import 'package:flutterprojects/viewmodels/user_viewmodel.dart';
import 'package:flutterprojects/viewmodels/wallet_viewmodel.dart';
import 'package:flutterprojects/viewmodels/payment_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '/views/widgets/custom_scaffold.dart';

class MyWalletScreen extends StatefulWidget {
  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {

  final UserViewModel userViewModel=UserViewModel();
  final WalletViewModel walletViewModel = WalletViewModel();
  final PaymentViewModel paymentViewModel = PaymentViewModel();

  List<dynamic> lastTransactionDetails = [];
  int lastTransactionDetailsLenght = 0;
  bool isFirstLoad = true;


  @override
  void initState() {
    super.initState();
    _loadTransactionsData();
  }

  Future<void> _loadTransactionsData() async {
    final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);

    if (isFirstLoad) {
      lastTransactionDetailsLenght = 0;

      isFirstLoad = false;
    }else{

      lastTransactionDetailsLenght = paymentViewModel.TransactionDetails.length;

    }
    paymentViewModel.TransactionDetails.clear();

    await paymentViewModel.getTransactions();

    if (paymentViewModel.TransactionDetails.isNotEmpty) {
      print("Transactions loaded successfully: ${paymentViewModel.TransactionDetails}");
    } else {
      print("No transactions loaded.");
    }

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
            walletViewModel.getWallet();
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
                    fontSize: 15
                ),
              ),

            ] else ...[
              Consumer<WalletViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.walletResponse.status == Status.LOADING) {
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  } else if (viewModel.walletResponse.status == Status.COMPLETED) {

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (viewModel.walletDetails.isNotEmpty) ...[
                            _buildInfoColumn('IBAN', viewModel.walletDetails[0]),
                            _buildInfoColumn('BALANCE', viewModel.walletDetails[1]),
                          ] else ...[
                            Text('No wallet details available.', style: TextStyle(color: Colors.grey)),
                          ],

                        ]
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
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  } else if (viewModel.paymentResponse.status == Status.COMPLETED) {
                    final transactionDetails = paymentViewModel.TransactionDetails;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (transactionDetails.isNotEmpty) ...[
                            SizedBox(height: 20),
                            Text(
                              'Transactions',
                              style: TextStyle(fontSize: 18),
                            ),
                            if (lastTransactionDetailsLenght != 0 && !isFirstLoad) ...[
                              if (transactionDetails[lastTransactionDetailsLenght] != null) ...[
                                for (int i = lastTransactionDetailsLenght; i < transactionDetails.length; i++)
                                  _buildInfoColumn2(transactionDetails[i]),
                              ],
                            ] else if (lastTransactionDetailsLenght == 0) ...[
                              for (int i = 0; i < transactionDetails.length; i++)
                                _buildInfoColumn2(transactionDetails[i]),
                            ],
                          ] else ...[
                            Text('No transactions available.', style: TextStyle(color: Colors.grey)),
                          ],
                        ]
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
            ],
          ],

        ),

      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4.0),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),

    );
  }
  Widget _buildInfoColumn2(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4.0),

          ],
        ),
      ),

    );
  }
}
