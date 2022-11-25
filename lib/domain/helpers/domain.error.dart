enum DomainError {
  unexpected,
  invalidCredecials,
  emailInUse,
}

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredecials:
        return 'Credenciais Inválidas';
      case DomainError.unexpected:
        return 'Algo errado aconteceu. Tente novamente em breve.';
      default:
        return '';
    }
  }
}
