class SaleModel {
  String idsale;
  String sale;

  SaleModel(
      {this.sale,
        this.idsale
      });

  SaleModel.fromJson(Map<String, dynamic> json) {
    idsale = json['id'];
    sale = json['sale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.idsale;
    data['sale'] = this.sale;
    return data;
  }
}
