String sanitizeJsonString(String jsonString) {
  print('Sanitizing JSON string: $jsonString');
  
  // First, trim any whitespace
  String cleaned = jsonString.trim();
  
  // Add quotes around unquoted property names
  cleaned = cleaned.replaceAllMapped(
    RegExp(r'(?<=\{|\,)\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*:'),
    (Match m) => '"${m.group(1)}":',
  );
  
  // Add quotes around unquoted string values
  cleaned = cleaned.replaceAllMapped(
    RegExp(r':\s*([a-zA-Z0-9._@]+)(?=\s*[,}])'),
    (Match m) => ':"${m.group(1)}"',
  );
  
  print('Sanitized result: $cleaned');
  return cleaned;
} 