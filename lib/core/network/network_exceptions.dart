class NetworkExceptions implements Exception {
  final String message;
  final int? statusCode;

  NetworkExceptions(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'NetworkException: $message (Status Code: $statusCode)';
    } else {
      return 'NetworkException: $message';
    }
  }
}
