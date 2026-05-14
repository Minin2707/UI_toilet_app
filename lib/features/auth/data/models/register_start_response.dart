class RegisterStartResponse {
  final Map<String, dynamic> json;

  const RegisterStartResponse({
    required this.json,
  });

  factory RegisterStartResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterStartResponse(
      json: json,
    );
  }
}