import 'package:flutter/material.dart';

class WeightDialog extends StatefulWidget{
  final double weight;
  final void Function(double) onSave;
  
  const WeightDialog(
    {
      super.key, 
      required this.weight,
      required this.onSave,
      }
  );


  @override
  State<StatefulWidget> createState() => _ActivityGoalDialogState();
}

class _ActivityGoalDialogState extends State<WeightDialog>{
  late TextEditingController _controller;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController(text: widget.weight.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(title: Text('Set Weight (Kg)'),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: 'Enter Weight In Kg}',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newWeight = double.tryParse(_controller.text);
            if (newWeight != null && newWeight > 0) {
              widget.onSave(newWeight);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}