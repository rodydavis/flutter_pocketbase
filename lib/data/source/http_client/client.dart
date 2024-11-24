import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';

Client Function() createHttpClient = kIsWeb //
    ? () => RetryClient(FetchClient(mode: RequestMode.cors))
    : () => RetryClient(Client());
