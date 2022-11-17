import '../protocols/protocols.dart';

import '../../presentation/protocols/validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String? validate({required String field, required String value}) {
    String? error;
    for (final validation in validations.where((e) => e.field == field)) {
      error = validation.validate(value);
      if (error?.isNotEmpty == true) {
        return error;
      }
    }
    return null;
  }
}