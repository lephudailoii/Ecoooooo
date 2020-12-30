class CommentModel {
  String idcm;
  String name;
  String cm;

  CommentModel(
      {this.name,
        this.idcm,
        this.cm,
        });

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idcm = json['idcm'];
    cm = json['cm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['idcm'] = this.idcm;
    data['cm'] = this.cm;
    return data;
  }
}
