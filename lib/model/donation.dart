class Donation {
  String id;
  String channelId;
  String denomAmount;
  String denomDescription;

  Donation({this.id, this.channelId, this.denomAmount, this.denomDescription});

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
        id: json['id'].toString(),
        channelId: json['channelID'].toString(),
        denomAmount: json['denomAmount'],
        denomDescription: json['denomDescription']);
  }
}
