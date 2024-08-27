import 'package:flutter/material.dart';
import 'package:split_it/widgets/modal_controls.dart';

import '../services/database.dart';

class AddSplit extends StatefulWidget {
  const AddSplit({super.key});

  @override
  State<AddSplit> createState() => _AddSplitState();
}

class _AddSplitState extends State<AddSplit> {
  final List<String> _contributors = ["Me"];
  final TextEditingController _contributorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  void _addContributor() {
    if (_contributorController.text.isEmpty) return;
    if (_contributors.contains(_contributorController.text)) return;
    setState(() {
      _contributors.add(_contributorController.text);
      _contributorController.clear();
    });
  }

  void createSplit() async {
    if (_titleController.text.isEmpty || _contributors.length < 2) return;
    await DB()
        .createSplit(_titleController.text, _contributors)
        .whenComplete(() {
      Navigator.of(context).pop();
    });
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
                const SizedBox(height: 20),
                _contributorsInput(),
                const SizedBox(height: 10),
                _contributorsList()
              ],
            ),
          ),
        ),
      ],
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
          trailing: index != 0
              ? IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _contributors.removeAt(index);
                    });
                  },
                )
              : null,
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
