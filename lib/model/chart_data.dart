class ChartData {
  final DateTime time;
  final double price;

  ChartData({required this.time, required this.price});

  factory ChartData.fromList(List<dynamic> data) {
    return ChartData(
      time: DateTime.fromMillisecondsSinceEpoch(data[0]),
      price: (data[1] as num).toDouble(),
    );
  }
}