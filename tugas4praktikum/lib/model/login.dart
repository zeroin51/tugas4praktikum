
class Login {
  int? code;
  bool? status;
  String? data;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.data, this.token,this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      return Login(
        code: obj['code'],
        status: obj['status'],
        token: obj['data']['token'],
        userID: int.parse(obj['data']['user']['id']),
        userEmail: obj['data']['user']['email'],
      );
    } else {
      return Login(
        code: obj['code'],
        status: obj['status'],
        data: obj['data'],
      );
    }
  }
}

