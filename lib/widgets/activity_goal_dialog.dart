import 'package:flutter/material.dart';

class ActivityGoalDialog extends StatefulWidget{
  final int currentGoal;
  final void Function(int) onSave;
  final String typeOfGoal;

  const ActivityGoalDialog(
    {
      super.key, 
      required this.currentGoal,
      required this.onSave,
      required this.typeOfGoal
      }
  );


  @override
  State<StatefulWidget> createState() => _ActivityGoalDialogState();
}

class _ActivityGoalDialogState extends State<ActivityGoalDialog>{
  late TextEditingController _controller;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController(text: widget.currentGoal.toString());
  }

  @override
  Widget build(BuildContext context){
    return AlertDialog(title: Text('Set Daily ${widget.typeOfGoal} Goal'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter ${widget.typeOfGoal.toLowerCase()}',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final newGoal = int.tryParse(_controller.text);
            if (newGoal != null && newGoal > 0) {
              widget.onSave(newGoal);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}