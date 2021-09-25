import 'dart:convert';

import 'dart:typed_data';

dynamic utf8JsonConverte(Uint8List responseBody) => jsonDecode(Utf8Decoder().convert(responseBody));
