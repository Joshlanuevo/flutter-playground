import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        double.tryParse(_amountController.text) != null;
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_onInputChanged);
    _amountController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text);
    final formattedDate = DateFormat.yMMMd().format(_selectedDate);

    print('Title: $title');
    print('Amount: \$${amount.toStringAsFixed(2)}');
    print('Date: $formattedDate');

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d{0,2}'),
              ),
            ],
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date',
              hintText: DateFormat.yMMMd().format(_selectedDate),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: _pickDate,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isFormValid ? _saveExpense : null,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
