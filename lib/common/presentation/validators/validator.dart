abstract class Validator {
  const Validator();

  Error? call(String? str);

  bool isValid(String? str) => call(str) == null;
}
