import 'package:dev_vault/data/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiClient', () {
    test('adds the backend Bearer authorization header', () {
      expect(
        ApiClient.authHeaders('test-token'),
        containsPair('Authorization', 'Bearer test-token'),
      );
    });

    test('does not send an authorization header without a token', () {
      expect(ApiClient.authHeaders(null), isEmpty);
      expect(ApiClient.authHeaders(''), isEmpty);
    });

    test('bounds API connection and response waits', () {
      expect(ApiClient.dio.options.connectTimeout, const Duration(seconds: 20));
      expect(ApiClient.dio.options.receiveTimeout, const Duration(seconds: 90));
    });
  });
}
