import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/models/expense.dart';
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Category _selectedCategory = Category.leisure;

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        double.tryParse(_amountController.text) != null;
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_onInputChanged);
    _amountController.addListener(_onInputChanged);
    _dateController.text = DateFormat.yMMMd().format(_selectedDate);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
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
        _dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  void _saveExpense() {
    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text);

    // print('Title: $title');
    // print('Amount: \$${amount.toStringAsFixed(2)}');
    // print('Date: $formattedDate');
    // print('Category: ${_selectedCategory.name}');

    final newExpense = Expense(
      title: title,
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
    );

    // Pass it back to parent
    widget.onAddExpense(newExpense);

    // Close the overlay / bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
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
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _pickDate,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButton<Category>(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: Category.values.map(
                    (category) => DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
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
