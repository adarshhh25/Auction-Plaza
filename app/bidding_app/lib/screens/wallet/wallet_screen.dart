import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/wallet_provider.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';

/// Wallet Screen
/// 
/// Manage wallet balance and add funds.
class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _showAddFundsDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter amount to add to your wallet'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
              ),
              validator: (value) =>
                  Validators.validatePositiveNumber(value, 'Amount'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addFunds();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFunds() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await ref.read(walletProvider.notifier).addFunds(amount);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Successfully added ${CurrencyFormatter.format(amount)} to wallet'),
          backgroundColor: Colors.green,
        ),
      );
      _amountController.clear();
    } else if (mounted) {
      final error = ref.read(walletProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to add funds'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final balance = walletState.balance?.balance ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(walletProvider.notifier).refresh(),
          ),
        ],
      ),
      body: walletState.isLoading && walletState.balance == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Balance Card
                  Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Available Balance',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CurrencyFormatter.format(balance),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add Funds Button
                  ElevatedButton.icon(
                    onPressed: _showAddFundsDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Funds'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Add Options
                  Text(
                    'Quick Add',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuickAddChip(
                        amount: 50,
                        onTap: () {
                          _amountController.text = '50';
                          _addFunds();
                        },
                      ),
                      _QuickAddChip(
                        amount: 100,
                        onTap: () {
                          _amountController.text = '100';
                          _addFunds();
                        },
                      ),
                      _QuickAddChip(
                        amount: 500,
                        onTap: () {
                          _amountController.text = '500';
                          _addFunds();
                        },
                      ),
                      _QuickAddChip(
                        amount: 1000,
                        onTap: () {
                          _amountController.text = '1000';
                          _addFunds();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Wallet Information',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '• Funds are used to place bids on auctions\n'
                            '• Winning bid amount will be deducted from your wallet\n'
                            '• Lost bids are automatically refunded\n'
                            '• Add funds securely anytime',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final double amount;
  final VoidCallback onTap;

  const _QuickAddChip({
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(CurrencyFormatter.format(amount)),
      onPressed: onTap,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }
}
