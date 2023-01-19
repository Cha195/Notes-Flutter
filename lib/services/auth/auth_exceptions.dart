// Register Exceptions
class UserNotFoundAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

// Login Exceptions
class InvalidEmailAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Generic Exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
