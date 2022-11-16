enum DomainError {
  unexpected,
  invalidCredecials,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch(this) {
      case DomainError.invalidCredecials: return 'Credenciais Inválidas';
      default: return '';
    }
  }
}
