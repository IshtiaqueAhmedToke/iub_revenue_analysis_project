import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:iub_revenue_analysis/models/revenue_analysis_page_model.dart';

class RevenueAnalysisTable extends StatelessWidget {
  const RevenueAnalysisTable({Key? key, this.loadedData}) : super(key: key);

  final List<RAPData>? loadedData;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 600,
      columns: const [
        DataColumn(
          label: Text('School'),
        ),
        DataColumn(
          label: Text('Semester'),
        ),
        DataColumn(
          label: Text('Year'),
        ),
        DataColumn(
          label: Text('Revenue'),
        ),
        DataColumn(
          label: Text('Revenue percentage'),
        ),
      ],
      rows: loadedData!.map((nameone) {
        return DataRow(//return table row in every loop
            cells: [
          //table cells inside table row
          DataCell(
            Text(nameone.School_ID!),
          ),
          DataCell(
            Text(nameone.SemesterNumber!),
          ),
          DataCell(Text(nameone.Year_No!)),
          DataCell(Text(nameone.Revenue!)),
          DataCell(Text('${int.parse(nameone.Revenue!) / 1000000}%')),
        ]);
      }).toList(),
    );
  }
}
