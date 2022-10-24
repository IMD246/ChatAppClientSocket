class Environment {
  late String baseURL;
  Environment({required bool isProduct}) {
    if (isProduct) {
      baseURL = "http://192.168.180.1:5000/api/";
    } else {
      baseURL = "http://192.168.180.1:5000/api/";
    }
  }
}
