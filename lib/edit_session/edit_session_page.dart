import 'package:flutter/material.dart';
import 'package:jbtimer/data/session.dart';
import 'package:jbtimer/main/session_controller.dart';

class EditSessionPage extends StatefulWidget {
  final void Function(Session session)? onSessionCreated;
  final SessionController? sessionController;

  final bool isEdit;

  const EditSessionPage({
    super.key,
    this.onSessionCreated,
    this.sessionController,
  }) : isEdit = sessionController != null;

  @override
  State<EditSessionPage> createState() => _EditSessionPageState();
}

class _EditSessionPageState extends State<EditSessionPage> {
  final TextEditingController _nameController = TextEditingController();

  bool _isValid = false;

  @override
  void initState() {
    _nameController.text = widget.sessionController?.value.name ?? '';
    _nameController.addListener(() {
      setState(() {
        _isValid = _isValidName();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Session' : 'New Session'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isValid ? _onSubmitButtonPressed : null,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: _nameController,
            ),
            const SizedBox(height: 24.0),
            DropdownMenu<String>(
              enableFilter: true,
              dropdownMenuEntries: [
                'None',
                '2x2',
                '3x3',
                '4x4',
                'Pyraminx',
                'Megaminx',
              ]
                  .map((item) => DropdownMenuEntry(value: item, label: item))
                  .toList(),
              label: const Text('Scramble'),
            ),
          ],
        ),
      ),
    );
  }

  _isValidName() {
    return _nameController.text.isNotEmpty &&
        _nameController.text != Session.defaultName;
  }

  _onSubmitButtonPressed() {
    if (widget.isEdit) {
      widget.sessionController?.rename(_nameController.text);
    } else {
      Session newSession = Session(name: _nameController.text);
      widget.onSessionCreated?.call(newSession);
    }
    Navigator.of(context).pop();
  }
}
