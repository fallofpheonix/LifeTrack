import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/vitals/blood_pressure_entry.dart';
import '../../data/models/vitals/heart_rate_entry.dart';
import '../../data/models/vitals/glucose_entry.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({
    super.key,
    required this.bpHistory,
    required this.hrHistory,
    required this.glucoseHistory,
    required this.onAddBP,
    required this.onAddHR,
    required this.onAddGlucose,
  });

  final List<BloodPressureEntry> bpHistory;
  final List<HeartRateEntry> hrHistory;
  final List<GlucoseEntry> glucoseHistory;
  final Function(BloodPressureEntry) onAddBP;
  final Function(HeartRateEntry) onAddHR;
  final Function(GlucoseEntry) onAddGlucose;

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  void _showAddBPDialog() {
    final TextEditingController sysController = TextEditingController();
    final TextEditingController diaController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log Blood Pressure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: sysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Systolic (mmHg)', hintText: '120'),
            ),
            TextField(
              controller: diaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Diastolic (mmHg)', hintText: '80'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final int? sys = int.tryParse(sysController.text);
              final int? dia = int.tryParse(diaController.text);
              if (sys != null && dia != null) {
                widget.onAddBP(BloodPressureEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  systolic: sys,
                  diastolic: dia,
                  date: DateTime.now(),
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddHRDialog() {
    final TextEditingController bpmController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log Heart Rate'),
        content: TextField(
          controller: bpmController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'BPM', hintText: '72'),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final int? bpm = int.tryParse(bpmController.text);
              if (bpm != null) {
                widget.onAddHR(HeartRateEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  bpm: bpm,
                  date: DateTime.now(),
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddGlucoseDialog() {
    final TextEditingController levelController = TextEditingController();
    GlucoseContext selectedContext = GlucoseContext.random;
    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text('Log Glucose'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: levelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Level (mg/dL)', hintText: '100'),
                ),
                const SizedBox(height: 16),
                DropdownButton<GlucoseContext>(
                  value: selectedContext,
                  isExpanded: true,
                  onChanged: (GlucoseContext? newValue) {
                    setDialogState(() {
                      selectedContext = newValue!;
                    });
                  },
                  items: GlucoseContext.values.map<DropdownMenuItem<GlucoseContext>>((GlucoseContext value) {
                    return DropdownMenuItem<GlucoseContext>(
                      value: value,
                      child: Text(value.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  final int? level = int.tryParse(levelController.text);
                  if (level != null) {
                    widget.onAddGlucose(GlucoseEntry(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      levelMgDl: level,
                      context: selectedContext,
                      date: DateTime.now(),
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVitalsCardWithChart({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onAdd,
    required List<dynamic> history,
    required VitalsChartType type,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: Icon(icon, color: color),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle_outline)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
                if (history.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('Latest', style: Theme.of(context).textTheme.bodySmall),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isNotEmpty)
              SizedBox(
                height: 120, // Chart Height
                width: double.infinity,
                child: CustomPaint(
                  painter: VitalsChartPainter(
                    history: history,
                    type: type,
                    color: color,
                  ),
                ),
              )
            else
               SizedBox(
                 height: 40,
                 child: Center(child: Text('No data yet', style: TextStyle(color: Colors.grey[400]))),
               ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String lastBP = widget.bpHistory.isNotEmpty
        ? '${widget.bpHistory.first.systolic}/${widget.bpHistory.first.diastolic}'
        : '--/--';
    final String lastHR = widget.hrHistory.isNotEmpty
        ? '${widget.hrHistory.first.bpm}'
        : '--';
    final String lastGlucose = widget.glucoseHistory.isNotEmpty
        ? '${widget.glucoseHistory.first.levelMgDl}'
        : '--';

    return Scaffold(
      appBar: AppBar(title: const Text('Vitals Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildVitalsCardWithChart(
            title: 'Blood Pressure',
            value: '$lastBP mmHg',
            subtitle: 'Systolic/Diastolic',
            icon: Icons.favorite_border,
            color: Colors.red,
            onAdd: _showAddBPDialog,
            history: widget.bpHistory,
            type: VitalsChartType.bloodPressure,
          ),
          _buildVitalsCardWithChart(
            title: 'Heart Rate',
            value: '$lastHR bpm',
            subtitle: 'Beats per minute',
            icon: Icons.monitor_heart,
            color: Colors.pink,
            onAdd: _showAddHRDialog,
            history: widget.hrHistory,
            type: VitalsChartType.heartRate,
          ),
          _buildVitalsCardWithChart(
            title: 'Glucose',
            value: '$lastGlucose mg/dL',
            subtitle: 'Blood Sugar Level',
            icon: Icons.water_drop,
            color: Colors.blue,
            onAdd: _showAddGlucoseDialog,
            history: widget.glucoseHistory,
            type: VitalsChartType.glucose,
          ),
          const SizedBox(height: 16),
          if (widget.bpHistory.isNotEmpty) ...[
             Text('Recent BP Log', style: Theme.of(context).textTheme.titleMedium),
             const SizedBox(height: 8),
             ...widget.bpHistory.take(3).map((BloodPressureEntry e) => Card(
               margin: const EdgeInsets.only(bottom: 8),
               child: ListTile(
                 leading: const Icon(Icons.favorite, color: Colors.red, size: 20),
                 title: Text('${e.systolic}/${e.diastolic} mmHg'),
                 subtitle: Text(DateFormat('MMM d, h:mm a').format(e.date)),
                 trailing: e.isHypertensive
                     ? const Chip(label: Text('High', style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.red)
                     : null,
               ),
             )),
          ]
        ],
      ),
    );
  }
}

enum VitalsChartType { bloodPressure, heartRate, glucose }

class VitalsChartPainter extends CustomPainter {
  VitalsChartPainter({required this.history, required this.type, required this.color});

  final List<dynamic> history;
  final VitalsChartType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;
    
    // Reverse history to have chronological order (Old -> New) for drawing left to right
    // Assuming 'history' is passed as New -> Old (descending date)
    final List<dynamic> data = history.take(15).toList().reversed.toList();
    if (data.isEmpty) return;

    final double width = size.width;
    final double height = size.height;
    
    final Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final Paint fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Get Min/Max
    double min = 0;
    double max = 100;

    if (type == VitalsChartType.bloodPressure) {
       // For BP we chart Systolic only for simplicity line, or we could do two lines.
       // Let's do Systolic and Diastolic.
       min = 40;
       max = 200;
       // We need two paths
    } else if (type == VitalsChartType.heartRate) {
       min = 40;
       max = 180;
    } else if (type == VitalsChartType.glucose) {
       min = 60;
       max = 300;
    }
    
    // Auto-scale
    if (type != VitalsChartType.bloodPressure) {
        // Find actual min/max in data
        final List<double> values = data.map((e) => type == VitalsChartType.heartRate ? (e as HeartRateEntry).bpm.toDouble() : (e as GlucoseEntry).levelMgDl.toDouble()).toList();
        double potentialMin = values.reduce((curr, next) => curr < next ? curr : next).toDouble();
        double potentialMax = values.reduce((curr, next) => curr > next ? curr : next).toDouble();
        
        // Add padding
        double range = potentialMax - potentialMin;
        if (range == 0) range = 20;
        min = (potentialMin - range * 0.2).clamp(0, double.infinity);
        max = (potentialMax + range * 0.2);
    }
    
    final double xStep = width / (data.length > 1 ? data.length - 1 : 1);
    
    if (type == VitalsChartType.bloodPressure) {
       // Draw Sys and Dia lines
       final Path sysPath = Path();
       final Path diaPath = Path();
       
       for(int i=0; i<data.length; i++) {
          final BloodPressureEntry e = data[i] as BloodPressureEntry;
          final double x = i * xStep;
          final double sysY = height - ((e.systolic - min) / (max - min) * height);
          final double diaY = height - ((e.diastolic - min) / (max - min) * height);
          
          if (i==0) {
             sysPath.moveTo(x, sysY);
             diaPath.moveTo(x, diaY);
          } else {
             sysPath.lineTo(x, sysY);
             diaPath.lineTo(x, diaY);
          }
          canvas.drawCircle(Offset(x, sysY), 3, dotPaint);
          canvas.drawCircle(Offset(x, diaY), 3, dotPaint..color = color.withValues(alpha: 0.6));
       }
       canvas.drawPath(sysPath, linePaint);
       canvas.drawPath(diaPath, linePaint..color = color.withValues(alpha: 0.6));
       
    } else {
       // Single chart
       final Path path = Path();
       final Path fillPath = Path();
       
       for(int i=0; i<data.length; i++) {
          final double val = type == VitalsChartType.heartRate ? (data[i] as HeartRateEntry).bpm.toDouble() : (data[i] as GlucoseEntry).levelMgDl.toDouble();
          final double x = i * xStep;
          final double y = height - ((val - min) / (max - min) * height);
          
          if (i==0) {
             path.moveTo(x, y);
             fillPath.moveTo(x, height); // Bottom left
             fillPath.lineTo(x, y);
          } else {
             path.lineTo(x, y);
             fillPath.lineTo(x, y);
          }
          canvas.drawCircle(Offset(x, y), 3, dotPaint);
          
           if (i == data.length - 1) {
             fillPath.lineTo(x, height); // Bottom right
             fillPath.close();
           }
       }
       
       canvas.drawPath(fillPath, fillPaint);
       canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant VitalsChartPainter oldDelegate) {
    return true; 
  }
}
