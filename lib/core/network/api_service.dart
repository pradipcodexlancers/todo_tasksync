import 'package:get/get.dart';

/// Base API Service
///
/// This service provides a foundation for making REST API network requests.
/// It uses GetX's built-in `GetConnect`, meaning no extra external network
/// library (like Dio or http) is required by default.
///
/// You can easily replace `GetConnect` with `Dio` if your project prefers it.
class ApiService extends GetConnect {
  // Base URL of your backend server
  // Update this to your active API endpoint (e.g., https://api.yourdomain.com/v1)
  static const String baseUrlString = 'https://jsonplaceholder.typicode.com';

  @override
  void onInit() {
    super.onInit();

    // Set base URL for all requests
    httpClient.baseUrl = baseUrlString;

    // Timeout duration for network calls
    httpClient.timeout = const Duration(seconds: 30);

    // Request Modifier / Interceptor:
    // Attach authorization tokens or custom headers before each request is sent
    httpClient.addRequestModifier<dynamic>((request) {
      // Example: Attach Bearer Token from storage
      // const token = 'YOUR_SAVED_AUTH_TOKEN';
      // request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    // Response Modifier / Interceptor:
    // Inspect or format responses globally, handle token expiry, etc.
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        // Handle unauthorized / expired session
        // e.g. Get.find<AuthController>().logout();
      }
      return response;
    });
  }

  /// Generic GET request helper
  Future<Response<T>> getRequest<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    return get<T>(endpoint, headers: headers, query: query);
  }

  /// Generic POST request helper
  Future<Response<T>> postRequest<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    return post<T>(endpoint, body, headers: headers);
  }

  /// Generic PUT request helper
  Future<Response<T>> putRequest<T>(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    return put<T>(endpoint, body, headers: headers);
  }

  /// Generic DELETE request helper
  Future<Response<T>> deleteRequest<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    return delete<T>(endpoint, headers: headers, query: query);
  }
}
