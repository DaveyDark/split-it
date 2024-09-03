import 'package:flutter/material.dart';
import 'package:split_it/utils/theme.dart';
import 'package:split_it/widgets/modal_controls.dart';

import '../services/database.dart';

class AddSplit extends StatefulWidget {
  const AddSplit({super.key});

  @override
  State<AddSplit> createState() => _AddSplitState();
}

class _AddSplitState extends State<AddSplit> {
  final List<String> _contributors = [];
  final TextEditingController _contributorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String _titleFeedback = '';
  String _contributorsFeedback = '';

  void _addContributor() {
    if (_contributorController.text.isEmpty) {
      setState(() {
        _contributorsFeedback = 'Please enter a name';
      });
      return;
    } else if (_contributorController.text.length > 20) {
      setState(() {
        _contributorsFeedback = 'Name must be less than 20 characters';
      });
      return;
    } else if (_contributors.contains(_contributorController.text)) {
      setState(() {
        _contributorsFeedback = 'Contributor already exists';
      });
      return;
    } else {
      setState(() {
        _contributorsFeedback = '';
      });
    }
    setState(() {
      _contributors.add(_contributorController.text);
      _contributorController.clear();
    });
  }

  void createSplit() {
    if (_titleController.text.isEmpty) {
      setState(() {
        _titleFeedback = 'Please enter a title';
      });
      return;
    } else if (_titleController.text.length < 3) {
      setState(() {
        _titleFeedback = 'Title must be at least 3 characters';
      });
      return;
    } else if (_titleController.text.length > 40) {
      setState(() {
        _titleFeedback = 'Title must be less than 50 characters';
      });
      return;
    } else {
      setState(() {
        _titleFeedback = '';
      });
    }
    if (_contributors.length < 2) {
      setState(() {
        _contributorsFeedback = 'At least 2 contributors are required';
      });
      return;
    } else if (_contributors.length > 10) {
      setState(() {
        _contributorsFeedback = 'Maximum of 10 contributors';
      });
      return;
    } else {
      setState(() {
        _contributorsFeedback = '';
      });
    }
    DB().createSplit(_titleController.text, _contributors).then(
      (_) {
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ModalControls(onConfirm: createSplit),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                const SizedBox(height: 20),
                _titleInput(),
                _feedback(_titleFeedback),
                const SizedBox(height: 20),
                _contributorsInput(),
                _feedback(_contributorsFeedback),
                const SizedBox(height: 10),
                _contributorsList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _feedback(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        style: const TextStyle(
          color: themeRed,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  TextField _titleInput() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title_outlined),
      ),
    );
  }

  Text _title() {
    return const Text(
      'Add Split',
      style: TextStyle(
        fontSize: 32,
      ),
      textAlign: TextAlign.left,
    );
  }

  ListView _contributorsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _contributors.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_contributors[index]),
          trailing: IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _contributors.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  Widget _contributorsInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Add a contributor',
            ),
            controller: _contributorController,
            onSubmitted: (_) => _addContributor(),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: _addContributor,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }
}
