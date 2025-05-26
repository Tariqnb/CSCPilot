import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../models/population_data.dart';

class PopulationGraphicChart extends StatelessWidget {
  final List<PopulationData> data;
  const PopulationGraphicChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final chartData = data
        .map((e) => {
              'year': int.tryParse(e.year) ?? 0,
              'population': e.population,
            })
        .toList();
    return Chart(
      data: chartData,
      variables: {
        'year': Variable(
          accessor: (Map map) => map['year'] as int,
          scale: LinearScale(tickCount: 5),
        ),
        'population': Variable(
          accessor: (Map map) => map['population'] as int,
          scale: LinearScale(),
        ),
      },
      marks: [
        LineMark(
          position: Varset('year') * Varset('population'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)), // <-- Correct here
          color: ColorEncode(value: Colors.deepPurple),
          size: SizeEncode(value: 3),
        ),
        PointMark(
          position: Varset('year') * Varset('population'),
          size: SizeEncode(value: 4),
          color: ColorEncode(value: Colors.deepPurpleAccent),
        ),
      ],
      axes: [
        Defaults.horizontalAxis,
        Defaults.verticalAxis,
      ],
      selections: {
        'hover': PointSelection(on: {GestureType.hover}),
        'tap': PointSelection(on: {GestureType.tap}),
        'scale': IntervalSelection(),
        },
      tooltip: TooltipGuide(
        followPointer: [true, true],
        align: Alignment.topCenter,
        offset: const Offset(0, -20),
      ),
      crosshair: CrosshairGuide(),
    );
  }
}