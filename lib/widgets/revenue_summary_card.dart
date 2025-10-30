import 'package:flutter/material.dart';
import '../models/revenue_summary_model.dart';
import '../utils/app_colors.dart';

class RevenueSummaryCard extends StatelessWidget {
  final RevenueSummaryModel summary;

  const RevenueSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Total revenue (USD)",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "\$${summary.totalRevenue.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "+\$${summary.revenueChange.toStringAsFixed(1)} ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF2C5E),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: "this week",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF959595),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// --- Sub-cards ---
          GridView.count(
            crossAxisCount: 2,
            // 2 columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            // Ensures height wraps around content
            physics: const NeverScrollableScrollPhysics(),
            // Prevents nested scrolling
            childAspectRatio: 16 / 9,
            // Adjust if you want a more square or rectangular shape
            children: [
              _buildMiniCard(
                title: "Orders",
                value: summary.orders.toString(),
                change: "+${summary.ordersChange} this week",
              ),
              _buildMiniCard(
                title: "Gross profit",
                value: "\$${summary.grossProfit}",
                change: "+\$${summary.grossProfitChange} this week",
              ),
              _buildMiniCard(
                title: "Pending orders",
                value: "\$${summary.pendingOrders.toStringAsFixed(2)}",
                change: "",
              ),
              _buildMiniCard(
                title: "Next payout",
                value: summary.nextPayout,
                change: "",
                highlight: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard({
    required String title,
    required String value,
    required String change,
    bool highlight = false,
  }) {
    final bool hasThisWeek = change.contains("this week");

    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: highlight ? AppColors.cream : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? AppColors.borderColorLightGreen : Colors.transparent,
          width: highlight ? 1.5 : 0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF222222),
            ),
          ),
          if (change.isNotEmpty) ...[
            const SizedBox(height: 3),
            if (hasThisWeek)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: change.replaceAll(" this week", ""),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFFF2C5E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const TextSpan(
                      text: " this week",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF959595),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                change,
                style: const TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
          ],
        ],
      ),
    );
  }
}
