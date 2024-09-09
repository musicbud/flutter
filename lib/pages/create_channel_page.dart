import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class CreateChannelPage extends StatefulWidget {
  final ChatService chatService;

  const CreateChannelPage({Key? key, required this.chatService}) : super(key: key);

  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final TextEditingController _channelNameController = TextEditingController();
  bool isLoading = false;

  Future<void> _createChannel() async {
    if (_channelNameController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      try {
        final response = await widget.chatService.createChannel({
          'name': _channelNameController.text,
        });
        if (response.data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Channel created successfully')),
          );
          Navigator.pop(context); // Navigate back to the channel list or desired page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating channel: ${response.data['message']}')),
          );
        }
      } catch (e) {
        print('Error creating channel: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a New Channel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _channelNameController,
              decoration: InputDecoration(
                labelText: 'Channel Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _createChannel,
              child: isLoading ? CircularProgressIndicator() : Text('Create Channel'),
            ),
          ],
        ),
      ),
    );
  }
}
