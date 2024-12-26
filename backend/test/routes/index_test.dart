import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /health', () {
    test('responds with a 200 and "ok".', () async {
      final context = _MockRequestContext();
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.body(),
        completion(equals('ok')),
      );
    });
  });
  group('GET /v1/login', () {
    test('responds with a 200 and "!".', () async {
      final context = _MockRequestContext();
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body(), completion(equals('ok')));
    });
  });
}
