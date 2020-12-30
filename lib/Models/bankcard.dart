class BankCardModel {
  String name;
  String idCard;
  String ccv;
  String sdt;

  BankCardModel(
      {this.name,
        this.idCard,
        this.ccv,
        this.sdt,});

  BankCardModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idCard = json['idCard'];
    ccv = json['ccv'];
    sdt = json['sdt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['idCard'] = this.idCard;
    data['ccv'] = this.ccv;
    data['sdt'] = this.sdt;
    return data;
  }
}
