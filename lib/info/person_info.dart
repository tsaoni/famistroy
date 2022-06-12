class PersonInfo{
    String uid = "";
    String acc = "";
    String pwd = "";
    String generation = "";
    String roles = "";
    String gender = "";
    String birth = "";
    String uname = "";
    String avatar = "";
    String theme = "";

    PersonInfo({required this.uid, required this.acc, required this.pwd, this.generation = "", this.roles = "",
        this.gender = "", this.birth = "", this.uname = "", this.avatar = "", this.theme = ""});
}

var currentUser;

