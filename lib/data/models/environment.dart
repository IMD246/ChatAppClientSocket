class Environment {
  late String baseURL;
  late String apiURL;
  Environment({required bool isProduct}) {
    if (isProduct) {
      baseURL = "https://chatappsocketclient.herokuapp.com";
      apiURL = "https://chatappsocketclient.herokuapp.com/api/";
    } else {
      baseURL = "http://172.16.22.13:5000";
      apiURL = "http://172.16.22.13:5000/api/";
    }
  }
}
