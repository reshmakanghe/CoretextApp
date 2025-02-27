import 'package:Coretext/utils/bottom_bar_widget/view_model/custom_bottom_bar.dart';
import 'package:Coretext/utils/constants/ColorConstant/color_constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PollAnalysis extends StatefulWidget {
  const PollAnalysis({super.key});

  @override
  State<PollAnalysis> createState() => _PollAnalysisState();
}

class _PollAnalysisState extends State<PollAnalysis> {
  int? _selectedOption;
  final List<int> _votes = [
    0,
    0,
    0,
    0
  ]; // Initialize votes for options A, B, C, D

  @override
  Widget build(BuildContext context) {
    // Screen responsiveness
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < -10) {
          Get.back(); // Navigate back to the previous screen
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(60.0), // Taller for a modern look
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:
                Colors.white, // Clean white background for a fresh look
            elevation: 5, // Slight shadow to add depth
            centerTitle: true, // Center the title for balance
            title: const Column(
              children: [
                Text(
                  "POLL",
                  style: TextStyle(
                    fontSize: 24.0, // Bigger text for a bold, modern look
                    fontWeight: FontWeight.w500, // Bold text for emphasis
                    color: Colors.black87, // Strong color for contrast
                    letterSpacing: 1.1, // More spacing for an elegant touch
                  ),
                ),
                SizedBox(height: 5.0), // Spacing between title and subtitle
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade200
                  ], // Subtle gradient for visual appeal
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question: PUhudb sdfudv iosdhnvbn sdbnusdbvujb sdcvnuibnsdv sdvhnodhv pnvdon NOionvonon?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20.0),
                    child: Column(
                      children: [
                        _buildOptionContainer('A', "Option 1"),
                        const SizedBox(height: 2),
                        _buildOptionContainer('B', "Option 2"),
                        const SizedBox(height: 2),
                        _buildOptionContainer('C', "Option 3"),
                        const SizedBox(height: 2),
                        _buildOptionContainer('D', "Option 4"),
                      ],
                    ),
                  ),
                  // Display the bar chart
                  SizedBox(
                    height: screenHeight * 0.4, // Adjust height as necessary
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 38,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return SideTitleWidget(
                                      meta: meta,
                                      //axisSide: meta.//axisSide,
                                      child: const Text('A'),
                                    );
                                  case 1:
                                    return SideTitleWidget(
                                      meta: meta,
                                      //axisSide: meta.//axisSide,
                                      child: const Text('B'),
                                    );
                                  case 2:
                                    return SideTitleWidget(
                                      meta: meta,
                                      //axisSide: meta.//axisSide,
                                      child: const Text('C'),
                                    );
                                  case 3:
                                    return SideTitleWidget(
                                      meta: meta,
                                      //axisSide: meta.//axisSide,
                                      child: const Text('D'),
                                    );
                                  default:
                                    return SideTitleWidget(
                                      meta: meta,
                                      //axisSide: meta.//axisSide,
                                      child: const Text(''),
                                    );
                                }
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _getBarGroups(),
                      ),
                    ),
                  ),
                ],
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Handle close action
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: appThemeColor,
              //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              //     elevation: 5,
              //   ),
              //   child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
              // ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(4, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _votes[index].toDouble(), // Votes for the option
            color: appThemeColor,
            width: 30, // Adjust bar width as needed
          ),
        ],
      );
    });
  }

  Widget _buildOptionContainer(String optionLetter, String optionText) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = optionLetter.codeUnitAt(0) -
              'A'.codeUnitAt(0) +
              1; // Convert letter to number (1-4)
          _votes[_selectedOption! -
              1]++; // Increment votes for the selected option
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedOption ==
                  optionLetter.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1
              ? Colors.white
              : const Color.fromARGB(255, 212, 211, 211),
          border: Border.all(
            width: 1,
            color: _selectedOption ==
                    optionLetter.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1
                ? appThemeColor
                : Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(optionLetter,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Expanded(child: Text(optionText)),
            ],
          ),
        ),
      ),
    );
  }
}
