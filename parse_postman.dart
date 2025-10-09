import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('lib/MusicBud.postman_collection.json');
  final content = file.readAsStringSync();
  final json = jsonDecode(content);
  final endpoints = <Map<String, dynamic>>[];

  void extractEndpoints(dynamic item, String prefix) {
    if (item is Map) {
      if (item.containsKey('request')) {
        // it's a request
        final request = item['request'];
        final name = item['name'];
        final method = request['method'];
        final url = request['url']['raw'];
        final body = request.containsKey('body') ? request['body'] : null;
        endpoints.add({
          'name': prefix.isEmpty ? name : '$prefix - $name',
          'method': method,
          'url': url,
          'body': body,
          'status': 'to_do'
        });
      } else if (item.containsKey('item')) {
        // it's a folder
        final newPrefix = prefix.isEmpty ? item['name'] : '$prefix - ${item['name']}';
        for (final subItem in item['item']) {
          extractEndpoints(subItem, newPrefix);
        }
      }
    }
  }

  for (final item in json['item']) {
    extractEndpoints(item, '');
  }

  print(jsonEncode(endpoints));
}