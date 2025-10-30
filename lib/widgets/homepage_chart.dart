import 'dart:math';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceLineChart extends StatefulWidget {
  const PriceLineChart({super.key});

  @override
  State<PriceLineChart> createState() => _PriceLineChartState();
}

class _PriceLineChartState extends State<PriceLineChart>
    with TickerProviderStateMixin {
  int _selectedRangeIndex = 1; // default 3d
  FlSpot? _touchedSpot;
  FlSpot? _defaultSpot;
  bool _isTouching = false;

  late final AnimationController _moveController;
  late final AnimationController _fadeController;
  late final Animation<double> _moveAnim;
  late final Animation<double> _fadeAnim;

  final _ranges = const ['24h', '3d', '1w', '2w', '1m', '3m'];

  final Map<String, List<FlSpot>> _data = {
    '24h': [
      FlSpot(0, 8200),
      FlSpot(1, 8800),
      FlSpot(2, 8600),
      FlSpot(3, 8350),
      FlSpot(4, 8100),
      FlSpot(5, 7900),
      FlSpot(6, 7700),
    ],
    '3d': [
      FlSpot(0, 10300),
      FlSpot(1, 8200),
      FlSpot(2, 6300),
      FlSpot(3, 5265.36),
      FlSpot(4, 3600),
      FlSpot(5, 2400),
      FlSpot(6, 1500),
    ],
    '1w': [
      FlSpot(0, 6500),
      FlSpot(1, 7200),
      FlSpot(2, 7600),
      FlSpot(3, 7800),
      FlSpot(4, 8200),
      FlSpot(5, 8400),
      FlSpot(6, 9000),
    ],
    '2w': [
      FlSpot(0, 4200),
      FlSpot(1, 4600),
      FlSpot(2, 4900),
      FlSpot(3, 5400),
      FlSpot(4, 5200),
      FlSpot(5, 5600),
      FlSpot(6, 6100),
    ],
    '1m': [
      FlSpot(0, 6800),
      FlSpot(1, 5900),
      FlSpot(2, 4200),
      FlSpot(3, 3000),
      FlSpot(4, 2500),
      FlSpot(5, 2200),
      FlSpot(6, 2000),
    ],
    '3m': [
      FlSpot(0, 3200),
      FlSpot(1, 2900),
      FlSpot(2, 2500),
      FlSpot(3, 2300),
      FlSpot(4, 2000),
      FlSpot(5, 1700),
      FlSpot(6, 1300),
    ],
  };

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _moveAnim = CurvedAnimation(parent: _moveController, curve: Curves.easeOutCubic);
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _defaultSpot = _data['3d']!.firstWhere((s) => s.y == 5265.36);
    _touchedSpot = _defaultSpot;
    _fadeController.value = 1.0;
  }

  void _revertToDefault() {
    if (_defaultSpot == null || _touchedSpot == null) return;
    _animateToSpot(_defaultSpot!, fade: true);
  }

  void _animateToSpot(FlSpot newSpot, {bool fade = false}) {
    final start = _touchedSpot ?? newSpot;
    final end = newSpot;

    if (fade) {
      _fadeController.reverse().then((_) {
        _moveController.reset();
        _moveController.addListener(() {
          if (!mounted) return;
          setState(() {
            _touchedSpot = FlSpot(
              lerpDouble(start.x, end.x, _moveAnim.value)!,
              lerpDouble(start.y, end.y, _moveAnim.value)!,
            );
          });
        });
        _moveController.forward().then((_) => _fadeController.forward());
      });
    } else {
      _fadeController.forward();
      _moveController.reset();
      _moveController.addListener(() {
        if (!mounted) return;
        setState(() {
          _isTouching = true;
          _touchedSpot = FlSpot(
            lerpDouble(start.x, end.x, _moveAnim.value)!,
            lerpDouble(start.y, end.y, _moveAnim.value)!,
          );
        });
      });
      _moveController.forward();
    }
  }

  @override
  void dispose() {
    _moveController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final range = _ranges[_selectedRangeIndex];
    final spots = _data[range]!;

    final rawMin = spots.map((s) => s.y).reduce(min);
    final rawMax = spots.map((s) => s.y).reduce(max);

    double minY = (rawMin / 1000).floor() * 1000 - 1000;
    double maxY = (rawMax / 1000).ceil() * 1000 + 1000;
    if (minY < 0) minY = 0;

    double interval;
    if (maxY - minY <= 6000) {
      interval = 1000;
    } else if (maxY - minY <= 12000) {
      interval = 2000;
    } else {
      interval = 5000;
    }

    _defaultSpot = range == '3d'
        ? spots.firstWhere((s) => s.y == 5265.36, orElse: () => spots[0])
        : null;
    _touchedSpot ??= _defaultSpot;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 280,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                final chartHeight = constraints.maxHeight;

                return Stack(
                  children: [
                    LineChart(
                      LineChartData(
                        minY: minY,
                        maxY: maxY,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.withValues(alpha : 0.2),
                            strokeWidth: 1,
                            dashArray: const [4, 4],
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              reservedSize: 42,
                              showTitles: true,
                              interval: interval,
                              getTitlesWidget: (value, _) {
                                if (value < minY || value > maxY) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  '${(value / 1000).toStringAsFixed(0)}K',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: const Color(0xFFFF5C8A),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: false),
                            dotData: FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: false,
                          touchCallback: (event, response) {
                            if (response == null) return;
                            if (response.lineBarSpots == null ||
                                response.lineBarSpots!.isEmpty) {
                              if (event.isInterestedForInteractions) {
                                final touchX = event.localPosition!.dx;
                                final index = ((touchX / chartWidth) *
                                    (spots.length - 1))
                                    .clamp(0, spots.length - 1)
                                    .round();
                                _animateToSpot(spots[index]);
                              } else if (_isTouching) {
                                _isTouching = false;
                                _revertToDefault();
                              }
                              return;
                            }

                            if (event.isInterestedForInteractions) {
                              final firstSpot = response.lineBarSpots!.first;
                              final s = FlSpot(firstSpot.x, firstSpot.y);
                              _animateToSpot(s);
                            }

                          },
                        ),
                      ),
                    ),

                    /// Fade-animated tooltip on top
                    if (_touchedSpot != null)
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: CustomPaint(
                          painter: _TooltipPainter(
                            spot: _touchedSpot!,
                            spots: spots,
                            minY: minY,
                            maxY: maxY,
                            chartWidth: chartWidth,
                            chartHeight: chartHeight,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildRangeSelector(),
      ],
    );
  }

  Widget _buildRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_ranges.length, (i) {
        final isSel = i == _selectedRangeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedRangeIndex = i;
              final range = _ranges[_selectedRangeIndex];
              _touchedSpot = _defaultSpot = range == '3d'
                  ? _data[range]!.firstWhere(
                    (s) => s.y == 5265.36,
                orElse: () => _data[range]!.first,
              )
                  : null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isSel ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.transparent,
                  width: 1.2,
                ),
              ),
              child: Text(
                _ranges[i],
                style: TextStyle(
                  color: isSel ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TooltipPainter extends CustomPainter {
  final FlSpot spot;
  final List<FlSpot> spots;
  final double minY;
  final double maxY;
  final double chartWidth;
  final double chartHeight;

  _TooltipPainter({
    required this.spot,
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.chartWidth,
    required this.chartHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = (spot.x / (spots.length - 1)) * chartWidth;
    final dy = (1 - (spot.y - minY) / (maxY - minY)) * chartHeight;

    const bubbleWidth = 90.0;
    const bubbleHeight = 32.0;
    const pointerHeight = 4.0;

    final bubbleRect = Rect.fromCenter(
      center: Offset(dx, dy - 36),
      width: bubbleWidth,
      height: bubbleHeight,
    );

    final bubblePaint = Paint()..color = const Color(0xFFFF5C8A);
    final rrect = RRect.fromRectAndRadius(bubbleRect, const Radius.circular(12));
    canvas.drawRRect(rrect, bubblePaint);

    final path = Path()
      ..moveTo(dx - 6, bubbleRect.bottom)
      ..lineTo(dx, bubbleRect.bottom + pointerHeight)
      ..lineTo(dx + 6, bubbleRect.bottom)
      ..close();
    canvas.drawPath(path, bubblePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$${spot.y.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(dx - textPainter.width / 2,
          bubbleRect.center.dy - textPainter.height / 2),
    );

    final circlePaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = const Color(0xFFFF5C8A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(dx, dy), 5, circlePaint);
    canvas.drawCircle(Offset(dx, dy), 5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/*
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class PriceLineChart extends StatefulWidget {
  const PriceLineChart({super.key});

  @override
  State<PriceLineChart> createState() => _PriceLineChartState();
}

class _PriceLineChartState extends State<PriceLineChart> {
  int _selectedRangeIndex = 1; // default 3d

  final List<String> _timeRanges = ['24h', '3d', '1w', '2w', '1m', '3m'];

  final Map<String, List<FlSpot>> _dataSets = {
    '24h': [
      FlSpot(0, 8200),
      FlSpot(1, 8800),
      FlSpot(2, 8600),
      FlSpot(3, 8350),
      FlSpot(4, 8100),
      FlSpot(5, 7900),
      FlSpot(6, 7700),
    ],
    '3d': [
      FlSpot(0, 10300),
      FlSpot(1, 8200),
      FlSpot(2, 6300),
      FlSpot(3, 5265.36),
      FlSpot(4, 3600),
      FlSpot(5, 2400),
      FlSpot(6, 1500),
    ],
    '1w': [
      FlSpot(0, 6500),
      FlSpot(1, 7200),
      FlSpot(2, 7600),
      FlSpot(3, 7800),
      FlSpot(4, 8200),
      FlSpot(5, 8400),
      FlSpot(6, 9000),
    ],
    '2w': [
      FlSpot(0, 4200),
      FlSpot(1, 4600),
      FlSpot(2, 4900),
      FlSpot(3, 5400),
      FlSpot(4, 5200),
      FlSpot(5, 5600),
      FlSpot(6, 6100),
    ],
    '1m': [
      FlSpot(0, 6800),
      FlSpot(1, 5900),
      FlSpot(2, 4200),
      FlSpot(3, 3000),
      FlSpot(4, 2500),
      FlSpot(5, 2200),
      FlSpot(6, 2000),
    ],
    '3m': [
      FlSpot(0, 3200),
      FlSpot(1, 2900),
      FlSpot(2, 2500),
      FlSpot(3, 2300),
      FlSpot(4, 2000),
      FlSpot(5, 1700),
      FlSpot(6, 1300),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final String currentRange = _timeRanges[_selectedRangeIndex];
    final spots = _dataSets[currentRange]!;

    const minY = 0.0;
    const maxY = 10000.0;
    const interval = 2000.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SizedBox(
            key: ValueKey(currentRange),
            height: 260,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.withValues(alpha : 0.2),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 40,
                        showTitles: true,
                        interval: interval,
                        getTitlesWidget: (value, _) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            '${(value / 1000).toStringAsFixed(0)}K',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.pinkAccent,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) {
                          if (spot.y == 5265.36 && currentRange == '3d') {
                            return FlDotCirclePainter(
                              radius: 5,
                              color: Colors.white,
                              strokeColor: Colors.pinkAccent,
                              strokeWidth: 2,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 0,
                            color: Colors.transparent,
                          );
                        },
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.pinkAccent,
                      tooltipBorderRadius: BorderRadius.circular(8),
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '\$${spot.y.toStringAsFixed(2)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildTimeRangeSelector(),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_timeRanges.length, (index) {
        final isSelected = index == _selectedRangeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => setState(() => _selectedRangeIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: isSelected
                      ?  1.2 : 0,
                  color: Colors.transparent
                ),
              ),
              child: Text(
                _timeRanges[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
*/

