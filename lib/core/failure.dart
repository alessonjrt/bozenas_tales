// lib/core/errors/failure.dart

abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message = 'Server Failure'});
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message = 'Network Failure'});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}
