class Environment {
  late String baseURL;
  late String apiURL;
  Environment({required bool isProduct}) {
    if (isProduct) {
      baseURL = "https://chatappsocket.onrender.com";
      apiURL = "https://chatappsocket.onrender.com/api/";
    } else {
      baseURL = "http://192.168.1.7:5000";
      apiURL = "http://192.168.1.7:5000/api/";
    }
  }
}
