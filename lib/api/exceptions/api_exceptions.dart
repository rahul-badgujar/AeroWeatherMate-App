// Interface for API Exceptions
abstract class ApiException implements Exception {}

// API Exceptions
class UnknownApiException extends ApiException {
  static const String errorMessage = "Unknown API Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}

class EmptyApiResultException extends ApiException {
  static const String errorMessage = "Empty Result API Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}

class RedirectionalApiException extends ApiException {
  static const String errorMessage = "Redirectional API Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}

class ClientSideErrorApiException extends ApiException {
  static const String errorMessage = "Client Side API Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}

class ServerSideApiException extends ApiException {
  static const String errorMessage = "Server Side API Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}

class ConnectionException extends ApiException {
  static const String errorMessage = "Connection Exception Occured";
  @override
  String toString() {
    return errorMessage;
  }
}
