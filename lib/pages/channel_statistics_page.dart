import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ChannelStatisticsPage extends StatefulWidget {
  final int channelId;
  final Dio dio;

  const ChannelStatisticsPage({Key? key, required this.channelId, required this.dio}) : super(key: key);

  @override
  _ChannelStatisticsPageState createState() => _ChannelStatisticsPageState();
}

class _ChannelStatisticsPageState extends State<ChannelStatisticsPage> {
  Map<String, dynamic>? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChannelStatistics();
  }

  Future<void> _fetchChannelStatistics() async {
    try {
      final response = await widget.dio.get('/chat/channel/${widget.channelId}/statistics/');
      if (response.statusCode == 200) {
        setState(() {
          _statistics = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Channel Statistics')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _statistics == null
              ? Center(child: Text('Failed to load statistics'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Statistics for Channel ${widget.channelId}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text('Total Messages: ${_statistics!['total_messages']}'),
                      Text('Active Users: ${_statistics!['active_users']}'),
                      // Add more statistics as needed
                    ],
                  ),
                ),
    );
  }
}
