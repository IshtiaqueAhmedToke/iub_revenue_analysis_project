import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iub_revenue_analysis/tables/revenue_analysis_table.dart';
import 'package:iub_revenue_analysis/widgets/app_bar.dart';
import 'package:iub_revenue_analysis/widgets/checkbox.dart';
import 'package:iub_revenue_analysis/widgets/school_dropdown.dart';
import 'package:iub_revenue_analysis/widgets/datagenerate_button.dart';
import 'package:iub_revenue_analysis/constants/color_constants.dart';
import 'package:iub_revenue_analysis/models/revenue_analysis_page_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RevenueAnalysisPage extends StatefulWidget {
  const RevenueAnalysisPage({Key? key}) : super(key: key);

  @override
  State<RevenueAnalysisPage> createState() => _RevenueAnalysisPageState();
}

class _RevenueAnalysisPageState extends State<RevenueAnalysisPage> {
  var rapData;
  List<RAPData> rapDataList = [];
  List<String> selectedSemesters = [];
  String selectedSchool = "SETS";

  @override
  void initState() {
    super.initState();
    getRAPData();
  }

  Future getRAPData() async {
    final response = await http
        .get(Uri.parse("http://localhost/PHP/revanalysis/rapTable.php"));
    final items = json.decode(response.body);
    print(response.statusCode);
    final myItems = <Map<String, dynamic>>[];
    for (var semester in selectedSemesters) {
      for (var x in items['data']) {
        if (x['SemesterName'] == semester) {
          if (x['School_ID'] == selectedSchool) {
            myItems.add(x);
          }
        }
      }
    }

    print(myItems);
    //print(items);

    return myItems;
  }

  @override
  Widget build(BuildContext context) {
    var _isvisible = false;
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Scaffold(
          appBar: const MyAppBar(
            pageName: 'Revenue Analysis',
          ),
          backgroundColor: Colors.white,
          body: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: kBackgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'select semester\'s: ',
                        ),
                      ),
                      SemesterCheckbox(
                        callback: (value) => selectedSemesters.add(value),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'select School: ',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SchoolDropdown(
                            sdCallback: (value) => selectedSchool = value,
                          ),
                        ],
                      ),
                      Divider(),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DataGenButton(
                            buttonName: 'Generate Data',
                            onPress: () async {
                              print(selectedSemesters);
                              print(selectedSchool);
                              rapData = await getRAPData();
                              rapDataList = List<RAPData>.from(rapData.map((i) {
                                return RAPData.fromJson(i);
                              }));
                              setState(() {
                                _isvisible = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: _isvisible == true
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView(
                          primary: false,
                          children: [
                            RevenueAnalysisTable(
                              loadedData: rapDataList,
                            )
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.white,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
