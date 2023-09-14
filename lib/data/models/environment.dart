class Environment {
  late String baseURL;
  late String apiURL;
  Environment({required bool isProduct}) {
    if (isProduct) {
      baseURL = "https://chatappsocket2.onrender.com";
      apiURL = "https://chatappsocket2.onrender.com/api/";
    } else {
      baseURL = "http://192.168.40.1:5000";
      apiURL = "http://192.168.40.1:5000/api/";
    }
  }
}
