enum Status { LOADING, COMPLETED, ERROR }

class ApiResponse<T> {
  Status status;
  T? data;
  String? message;

  ApiResponse.loading() : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;
}
