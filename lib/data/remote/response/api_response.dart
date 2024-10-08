enum Status { LOADING, COMPLETED, ERROR }

class ApiResponse<T> {
  final T? data;
  final String? error;
  final Status status;

  ApiResponse._(this.status, this.data, this.error);

  factory ApiResponse.loading() => ApiResponse._(Status.LOADING, null, null);
  factory ApiResponse.completed(T data) => ApiResponse._(Status.COMPLETED, data, null);
  factory ApiResponse.error(String error) => ApiResponse._(Status.ERROR, null, error);
}
