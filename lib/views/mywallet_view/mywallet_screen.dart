import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_pos/viewmodels/user_viewmodel.dart';
import 'package:e_pos/viewmodels/wallet_viewmodel.dart';
import 'package:e_pos/viewmodels/payment_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/remote/response/api_response.dart';
import '/views/widgets/custom_scaffold.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

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
      title: 'Cüzdanım',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
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
              const SizedBox(height: 25),
              const Text(
                'Şirketinizin Bir Cüzdanı Yok',
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
                          const Text('Cüzdan bilgileri bulunamadı.', style: TextStyle(color: Colors.grey)),
                        ],
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Bir hata oluştu.',
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
                        title: const Center(
                          child: Text(
                            'İşlem Geçmişi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        initiallyExpanded: false,
                        children: [
                          Container(
                            height: 10, // Adjust the height as needed
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
                        title: const Center(
                          child: Text(
                            'İşlem Geçmişi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        initiallyExpanded: true,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.45,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: transactionDetails.isNotEmpty
                                    ? transactionDetails.map<Widget>((transaction) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: const Icon(
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
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.lightGreen
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Center(
                                                child: Text(
                                                  transaction.date,
                                                  style: const TextStyle(
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
                                    : [const Center(child: Text('Bir işlem bulunmuyor.', style: TextStyle(color: Colors.grey)))],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Bir hata oluştu.',
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
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.deepPurpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
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
          const Text(
            'IBAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            iban,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'BAKİYE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${formatNumberWithDots(balance)},00 TL',
            style: const TextStyle(
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
