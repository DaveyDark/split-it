import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_it/services/database.dart';
import 'package:split_it/models/split.dart' as split_model;
import 'package:split_it/widgets/modal_controls.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({
    super.key,
    required this.split,
  });

  final split_model.Split split;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  late String _selectedContributor;

  void _addTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }
    await DB()
        .createTransaction(
      widget.split.id,
      _titleController.text,
      double.parse(_amountController.text),
      _selectedContributor,
    )
        .whenComplete(() {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedContributor = widget.split.contributors[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ModalControls(onConfirm: _addTransaction),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _contributorsSelect()),
                    const SizedBox(width: 20),
                    Expanded(child: _amountInput()),
                  ],
                ),
                const SizedBox(height: 20),
                _titleInput(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return const Text(
      'Add Transaction',
      style: TextStyle(
        fontSize: 32,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _titleInput() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.text_snippet),
      ),
    );
  }

  Widget _contributorsSelect() {
    return DropdownMenu<String>(
      initialSelection: _selectedContributor,
      onSelected: (selected) {
        setState(() {
          _selectedContributor = selected!;
        });
      },
      dropdownMenuEntries: widget.split.contributors
          .map((String contributor) => DropdownMenuEntry<String>(
                value: contributor,
                label: contributor,
              ))
          .toList(),
    );
  }

  Widget _amountInput() {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
      ],
      decoration: const InputDecoration(
        labelText: 'Amount',
        prefixIcon: Icon(Icons.currency_rupee),
      ),
    );
  }
}
