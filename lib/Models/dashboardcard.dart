class DashBoardModel {
  double totalAmount;

  DashBoardModel(
      {this.totalAmount
        });

  DashBoardModel.fromJson(Map<String, dynamic> json) {
      totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
