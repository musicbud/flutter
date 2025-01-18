import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class CreateChannelPage extends StatefulWidget {
  final ChatService chatService;

  const CreateChannelPage({Key? key, required this.chatService})
      : super(key: key);

  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPrivate = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _createChannel() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await widget.chatService.createChannel({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'is_private': _isPrivate,
        });

        if (!mounted) return;

        if (response['status'] == 'success') {
          Navigator.pop(context, true);
        } else {
          _showSnackBar('Error creating channel: ${response['message']}');
        }
      } catch (e) {
        print('Error creating channel: $e');
        if (!mounted) return;
        _showSnackBar('An error occurred. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Channel'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Channel Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a channel name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              SwitchListTile(
                title: const Text('Private Channel'),
                value: _isPrivate,
                onChanged: (bool value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _createChannel,
                child: const Text('Create Channel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
