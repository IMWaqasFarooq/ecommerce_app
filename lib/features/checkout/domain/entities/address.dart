import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    required this.fullName,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
  });

  final String fullName;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;

  String get formatted {
    final parts = [fullName, line1, if (line2 != null && line2!.isNotEmpty) line2, '$city, $state $postalCode', country];
    return parts.join('\n');
  }

  @override
  List<Object?> get props => [fullName, line1, line2, city, state, postalCode, country, phone];
}
