class ApiResponse<T> {
  final Status status;
  final T? data;
  final String? message;

  ApiResponse.loading() : status = Status.loading, data = null, message = null;
  ApiResponse.completed(this.data) : status = Status.completed, message = null;
  ApiResponse.error(this.message) : status = Status.error, data = null;
}

enum Status { loading, completed, error }
