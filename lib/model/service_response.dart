class ServiceResponse {
  final bool status;
  final String? statusCode;
  final String message;
  final data;

  ServiceResponse({
    required this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "statusCode": statusCode,
      "message": message,
      "data": data,
    };
  }

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      status: json["status"],
      statusCode: json.containsKey("statusCode") ? json["statusCode"] : null,
      message: json["message"],
      data: json.containsKey("data") ? json["data"] : null,
    );
  }
}
