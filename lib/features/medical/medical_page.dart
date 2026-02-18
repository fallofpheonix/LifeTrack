import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/disease_info.dart';
import '../../data/models/health_record_entry.dart';
import '../../data/models/clinical/recovery_data_point.dart';
import '../../data/models/scientist.dart';
import '../../data/models/content/news_item.dart';
import '../../core/services/disease_service.dart';
import '../../core/utils/animated_fade_slide.dart';

class MedicalPage extends StatefulWidget {
  const MedicalPage({
    super.key,
    required this.diseaseGuide,
    required this.records,
    required this.recoveryData,
    required this.scientists,
    required this.news,
    required this.onAddRecord,
    required this.onDeleteRecord,
    required this.onOpenVitals,
  });

  final List<DiseaseInfo> diseaseGuide;
  final List<HealthRecordEntry> records;
  final List<RecoveryDataPoint> recoveryData;
  final List<Scientist> scientists;
  final List<NewsItem> news;
  final ValueChanged<HealthRecordEntry> onAddRecord;
  final ValueChanged<String> onDeleteRecord;
  final VoidCallback onOpenVitals;

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _search = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showAddRecordDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController conditionController = TextEditingController();
    final TextEditingController vitalsController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    final bool? didSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Health Record'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: conditionController,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Condition is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: vitalsController,
                  decoration: const InputDecoration(labelText: 'Vitals'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vitals are required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Note is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final DateTime now = DateTime.now();
                  final String date =
                      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                  widget.onAddRecord(
                    HealthRecordEntry(
                      id: now.microsecondsSinceEpoch.toString(),
                      dateLabel: date,
                      condition: conditionController.text.trim(),
                      vitals: vitalsController.text.trim(),
                      note: noteController.text.trim(),
                    ),
                  );
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    conditionController.dispose();
    vitalsController.dispose();
    noteController.dispose();

    if (didSave ?? false) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine local guide with API results if needed, or just filter local.
    // Logic: If search matches local, show local. If not, show API result if available.
    // For now, we filter local.
    final List<DiseaseInfo> filteredDiseases = widget.diseaseGuide.where((DiseaseInfo disease) {
      if (_search.isEmpty) {
        return true;
      }
      return disease.name.toLowerCase().contains(_search) ||
          disease.symptoms.toLowerCase().contains(_search) ||
          disease.precautions.toLowerCase().contains(_search);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _MedicalHeader(
           onSearch: (String query) async {
             // Trigger API search for single item
             final DiseaseService service = DiseaseService();
             final DiseaseInfo? info = await service.fetchDiseaseFromWiki(query);
             if (info != null && mounted) {
                // Show result dialog
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(info.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (info.thumbnailUrl != null) 
                           Center(child: Image.network(info.thumbnailUrl!, height: 100)),
                        const SizedBox(height: 10),
                        const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(info.symptoms),
                         const SizedBox(height: 8),
                         const Text('Source: Wikipedia API', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                      ],
                    ),
                    actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Close'))],
                  ),
                );
             }
           },
        ),
        if (widget.news.isNotEmpty) ...<Widget>[
           const SizedBox(height: 16),
           Text('Medical Innovations', style: Theme.of(context).textTheme.titleLarge),
           const SizedBox(height: 8),
           SizedBox(
             height: 140,
             child: ListView.separated(
               scrollDirection: Axis.horizontal,
               itemCount: widget.news.length,
               separatorBuilder: (_, __) => const SizedBox(width: 12),
               itemBuilder: (BuildContext context, int index) {
                 return NewsCard(item: widget.news[index]);
               },
             ),
           ),
        ],
        const SizedBox(height: 16),
        _VitalsNavigationCard(onTap: widget.onOpenVitals),
        const SizedBox(height: 16),
        Text('Pioneers of Medicine', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.scientists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              return ScientistCard(scientist: widget.scientists[index]);
            },
          ),
        ),
        const SizedBox(height: 20),
        Text('Disease Guide (Dictionary)', style: Theme.of(context).textTheme.titleLarge),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Disease Guide', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                const Text('Educational support only. Not a medical diagnosis.'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    Chip(
                      avatar: const Icon(Icons.menu_book, size: 16),
                      label: Text('${widget.diseaseGuide.length} conditions'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.event_note, size: 16),
                      label: Text('${widget.records.length} records'),
                    ),
                  ],
                ),
        const SizedBox(height: 10),
        TextField(
          key: const ValueKey<String>('disease_search'),
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Filter local dictionary...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        ...filteredDiseases.asMap().entries.map((MapEntry<int, DiseaseInfo> entry) {
          final int index = entry.key;
          final DiseaseInfo disease = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 90 + (index * 40)),
            child: Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.health_and_safety)),
              title: Text(disease.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Symptoms: ${disease.symptoms}'),
                  Text('Prevention: ${disease.prevention}'),
                  Text('Cure: ${disease.cure}'),
                ],
              ),
            ),
            ),
          );
        }),
        if (filteredDiseases.isEmpty)
          const Card(
            child: ListTile(
              title: Text('No matching disease information found.'),
            ),
          ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Health Records', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              key: const ValueKey<String>('add_record_button'),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showAddRecordDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...widget.records.asMap().entries.map((MapEntry<int, HealthRecordEntry> entry) {
          final int index = entry.key;
          final HealthRecordEntry record = entry.value;
          return AnimatedFadeSlide(
            delay: Duration(milliseconds: 110 + (index * 40)),
            child: Dismissible(
            key: ValueKey<String>(record.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Theme.of(context).colorScheme.errorContainer,
              child: const Icon(Icons.delete_outline),
            ),
            onDismissed: (_) {
              widget.onDeleteRecord(record.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record deleted')),
              );
            },
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.event_note)),
                title: Text('${record.dateLabel} - ${record.condition}'),
                subtitle: Text('${record.vitals}\n${record.note}'),
              ),
            ),
            ),
          );
        }),
        const SizedBox(height: 10),
        // RecoveryTrendCard(data: widget.recoveryData), // Disabled due to model mismatch
        Text('Recovery Metrics', style: Theme.of(context).textTheme.titleLarge),
        ...widget.recoveryData.map((data) => Card(
          child: ListTile(
            title: Text(data.label),
            trailing: Text(data.value, style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(data.status),
          ),
        )),
      ],
    );
  }
}

/*
class RecoveryTrendCard extends StatelessWidget {
  // ... (Commented out to avoid errors)
  @override
  Widget build(BuildContext context) => const SizedBox();
}
*/

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

/*
class RecoveryChartPainter extends CustomPainter {
  // ... (Commented out to avoid errors)
  @override
  void paint(Canvas canvas, Size size) {}
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
*/

class ScientistCard extends StatelessWidget {
  const ScientistCard({super.key, required this.scientist});

  final Scientist scientist;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Image.network(
              scientist.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey, child: const Icon(Icons.person, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(scientist.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(scientist.contribution, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.item});

  final NewsItem item;

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(item.link);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        child: InkWell(
          onTap: _launchUrl,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                   children: [
                     Icon(Icons.newspaper, size: 16, color: Theme.of(context).colorScheme.primary),
                     const SizedBox(width: 8),
                     Expanded(child: Text(item.date.toLocal().toString().split(' ')[0], style: Theme.of(context).textTheme.bodySmall, maxLines: 1)),
                   ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                const Text('Read more', style: TextStyle(color: Colors.blue, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicalHeader extends StatelessWidget {
  const _MedicalHeader({required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Medical Hub', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Wikipedia for Diseases...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => onSearch(controller.text.trim()),
                ),
              ),
              onSubmitted: (String val) => onSearch(val.trim()),
            ),
          ],
        ),
      ),
    );
  }
}

class _VitalsNavigationCard extends StatelessWidget {
  const _VitalsNavigationCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.monitor_heart, color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vitals Dashboard', 
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    ),
                    Text(
                      'Track BP, Heart Rate, and Glucose', 
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                         color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      )
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
