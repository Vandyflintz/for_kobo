import 'package:flutter/material.dart';
import 'package:forkobo/models/order_statistics_model.dart';

class OrderStatisticsRow extends StatefulWidget {
  final List<OrderStatisticsModel> orderStatistics;

  const OrderStatisticsRow({super.key, required this.orderStatistics});

  @override
  State<OrderStatisticsRow> createState() => _OrderStatisticsRowState();
}

class _OrderStatisticsRowState extends State<OrderStatisticsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.orderStatistics.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha : 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stat.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon( Icons.inbox, size: 16, color: Color(0xFF959595),)
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  stat.label,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
