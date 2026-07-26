import 'package:dio/dio.dart';

abstract class PaymentsRemoteDataSource {
  Future<String> createPaymentIntentClientSecret({required int amountInSmallestUnit, required String currency});
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  PaymentsRemoteDataSourceImpl(this._dio, {required this.functionUrl});

  final Dio _dio;
  final String functionUrl;

  @override
  Future<String> createPaymentIntentClientSecret({
    required int amountInSmallestUnit,
    required String currency,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      functionUrl,
      data: {'amount': amountInSmallestUnit, 'currency': currency},
    );
    return response.data!['clientSecret'] as String;
  }
}
