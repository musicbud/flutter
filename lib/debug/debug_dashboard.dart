// ignore_for_file: dangling_library_doc_comments

/// Debug Dashboard
/// 
/// A comprehensive debugging dashboard for development and testing
/// Access via FloatingActionButton in debug mode
library;

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class DebugDashboard extends StatefulWidget {
  const DebugDashboard({super.key});

  @override
  State<DebugDashboard> createState() => _DebugDashboardState();
}

class _DebugDashboardState extends State<DebugDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _logs = [];
  final List<Map<String, dynamic>> _networkCalls = [];
  final List<Map<String, dynamic>> _blocEvents = [];
  late Timer _performanceTimer;
  
  final double _memoryUsage = 0.0;
  int _fps = 60;
  Duration _frameTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _startPerformanceMonitoring();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _performanceTimer.cancel();
    super.dispose();
  }

  void _startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Simulate performance metrics (in production, use actual metrics)
          _fps = 58 + (timer.tick % 5);
          _frameTime = Duration(milliseconds: 16 + (timer.tick % 3));
        });
      }
    });
  }

  void _addLog(String message, {String level = 'INFO'}) {
    setState(() {
      _logs.insert(0, '[$level] ${DateTime.now().toString().substring(11, 19)}: $message');
      if (_logs.length > 100) _logs.removeLast();
    });
  }

  void _addNetworkCall(String method, String url, int? statusCode, Duration duration) {
    setState(() {
      _networkCalls.insert(0, {
        'time': DateTime.now(),
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'duration': duration,
      });
      if (_networkCalls.length > 50) _networkCalls.removeLast();
    });
  }

  // Unused but kept for future dashboard integration
  // void _addBlocEvent(String blocName, String eventName, String stateName) {
  //   setState(() {
  //     _blocEvents.insert(0, {
  //       'time': DateTime.now(),
  //       'bloc': blocName,
  //       'event': eventName,
  //       'state': stateName,
  //     });
  //     if (_blocEvents.length > 50) _blocEvents.removeLast();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🐛 Debug Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Overview'),
            Tab(icon: Icon(Icons.code), text: 'Logs'),
            Tab(icon: Icon(Icons.network_check), text: 'Network'),
            Tab(icon: Icon(Icons.layers), text: 'BLoCs'),
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildLogsTab(),
          _buildNetworkTab(),
          _buildBlocsTab(),
          _buildPerformanceTab(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'clear',
            mini: true,
            onPressed: () {
              setState(() {
                _logs.clear();
                _networkCalls.clear();
                _blocEvents.clear();
              });
            },
            child: const Icon(Icons.clear_all),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'close',
            mini: true,
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          title: 'App Info',
          children: [
            _buildInfoRow('Build Mode', kDebugMode ? 'Debug' : 'Release'),
            _buildInfoRow('Platform', defaultTargetPlatform.toString()),
            _buildInfoRow('Dart Version', Platform.version.split(' ')[0]),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'Quick Stats',
          children: [
            _buildInfoRow('Total Logs', _logs.length.toString()),
            _buildInfoRow('Network Calls', _networkCalls.length.toString()),
            _buildInfoRow('BLoC Events', _blocEvents.length.toString()),
            _buildInfoRow('FPS', '$_fps'),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'Actions',
          children: [
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Generate Test Error'),
              onTap: () {
                _addLog('Test error generated', level: 'ERROR');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test error logged')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.network_ping),
              title: const Text('Simulate Network Call'),
              onTap: () {
                _addNetworkCall('GET', '/api/test', 200, const Duration(milliseconds: 245));
                _addLog('Simulated network call', level: 'INFO');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Clear All Data'),
              onTap: () {
                setState(() {
                  _logs.clear();
                  _networkCalls.clear();
                  _blocEvents.clear();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${_logs.length} logs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement log filtering
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _logs.isEmpty
              ? const Center(child: Text('No logs yet'))
              : ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    final isError = log.contains('[ERROR]');
                    final isWarning = log.contains('[WARNING]');
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: isError
                          ? Colors.red.shade50
                          : isWarning
                              ? Colors.orange.shade50
                              : null,
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          isError
                              ? Icons.error
                              : isWarning
                                  ? Icons.warning
                                  : Icons.info,
                          color: isError
                              ? Colors.red
                              : isWarning
                                  ? Colors.orange
                                  : Colors.blue,
                          size: 20,
                        ),
                        title: Text(
                          log,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildNetworkTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${_networkCalls.length} network calls',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: _networkCalls.isEmpty
              ? const Center(child: Text('No network calls yet'))
              : ListView.builder(
                  itemCount: _networkCalls.length,
                  itemBuilder: (context, index) {
                    final call = _networkCalls[index];
                    final isError = (call['statusCode'] as int?) != null && 
                                   (call['statusCode'] as int) >= 400;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ExpansionTile(
                        leading: Icon(
                          isError ? Icons.error : Icons.check_circle,
                          color: isError ? Colors.red : Colors.green,
                        ),
                        title: Text(
                          '${call['method']} ${call['statusCode'] ?? 'pending'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          call['url'],
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '${(call['duration'] as Duration).inMilliseconds}ms',
                          style: TextStyle(
                            color: (call['duration'] as Duration).inMilliseconds > 1000
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time: ${call['time']}'),
                                Text('URL: ${call['url']}'),
                                Text('Method: ${call['method']}'),
                                Text('Status: ${call['statusCode'] ?? 'N/A'}'),
                                Text('Duration: ${(call['duration'] as Duration).inMilliseconds}ms'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBlocsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${_blocEvents.length} BLoC events',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: _blocEvents.isEmpty
              ? const Center(child: Text('No BLoC events yet'))
              : ListView.builder(
                  itemCount: _blocEvents.length,
                  itemBuilder: (context, index) {
                    final event = _blocEvents[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ExpansionTile(
                        leading: const Icon(Icons.layers, color: Colors.purple),
                        title: Text(
                          event['bloc'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Event: ${event['event']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time: ${event['time']}'),
                                Text('BLoC: ${event['bloc']}'),
                                Text('Event: ${event['event']}'),
                                Text('New State: ${event['state']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPerformanceTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          title: 'Frame Performance',
          children: [
            _buildPerformanceIndicator('FPS', _fps, 60, Colors.green),
            _buildPerformanceIndicator('Frame Time', _frameTime.inMilliseconds, 16, Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'Memory',
          children: [
            ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('Memory Usage'),
              trailing: Text('${_memoryUsage.toStringAsFixed(1)} MB'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCard(
          title: 'Tools',
          children: [
            ListTile(
              leading: const Icon(Icons.timeline),
              title: const Text('Enable Performance Overlay'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Enable performance overlay
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brush),
              title: const Text('Show Paint Overlay'),
              trailing: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Enable paint overlay
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicator(String label, int value, int target, Color color) {
    final percentage = (value / target * 100).clamp(0, 100);
    final isGood = value >= target * 0.9;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '$value / $target',
                style: TextStyle(
                  color: isGood ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isGood ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

/// Debug Floating Action Button
/// Shows debug dashboard when tapped (only in debug mode)
class DebugFAB extends StatelessWidget {
  const DebugFAB({super.key});

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DebugDashboard()),
        );
      },
      child: const Icon(Icons.bug_report, color: Colors.white),
    );
  }
}

/// BLoC Observer for debugging
class DebugBlocObserver extends BlocObserver {
  final void Function(String bloc, String event, String state)? onEventLogged;

  DebugBlocObserver({this.onEventLogged});

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('🔵 ${bloc.runtimeType} Event: ${event.runtimeType}');
    onEventLogged?.call(
      bloc.runtimeType.toString(),
      event.runtimeType.toString(),
      bloc.state.runtimeType.toString(),
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('🟢 ${bloc.runtimeType} Change: ${change.currentState.runtimeType} → ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('🔴 ${bloc.runtimeType} Error: $error');
    debugPrint('StackTrace: $stackTrace');
  }
}

/// Network logger for debugging
class DebugDioInterceptor extends Interceptor {
  final void Function(String method, String url, int? statusCode, Duration duration)? onRequestLogged;

  DebugDioInterceptor({this.onRequestLogged});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🌐 [${options.method}] ${options.uri}');
    options.extra['start_time'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;
    
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.uri} (${duration.inMilliseconds}ms)');
    
    onRequestLogged?.call(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode,
      duration,
    );
    
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;
    
    debugPrint('❌ [${err.response?.statusCode}] ${err.requestOptions.uri} (${duration.inMilliseconds}ms)');
    debugPrint('Error: ${err.message}');
    
    onRequestLogged?.call(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      err.response?.statusCode,
      duration,
    );
    
    super.onError(err, handler);
  }
}
