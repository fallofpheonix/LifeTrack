import 'package:flutter/material.dart';
import '../../core/services/life_track_store.dart';
import '../../data/models/disease_info.dart';
import '../../data/models/health_record_entry.dart';
import '../../data/models/scientist.dart';

class GlobalSearchDelegate extends SearchDelegate {
  final LifeTrackStore store;

  GlobalSearchDelegate(this.store);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Search diseases, records, or scientists...',
          style: TextStyle(color: Colors.grey[500]),
        ),
      );
    }

    final String q = query.toLowerCase();

    // Filter using Store methods
    final List<DiseaseInfo> diseases = store.searchDiseases(q);
    final List<Scientist> scientists = store.searchScientists(q);
    final List<HealthRecordEntry> records = store.searchRecords(q);

    if (diseases.isEmpty && scientists.isEmpty && records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No results found for "$query"', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView(
      children: [
        if (diseases.isNotEmpty) ...[
          _buildHeader(context, 'Diseases'),
          ...diseases.map((d) => ListTile(
            leading: const Icon(Icons.medical_services),
            title: Text(d.name),
            subtitle: Text(d.symptoms, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              // TODO: Navigate to detail
              close(context, null);
              // In real app, return result or navigate
            },
          )),
        ],
        if (scientists.isNotEmpty) ...[
          _buildHeader(context, 'Scientists'),
          ...scientists.map((s) => ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(s.imageUrl)),
            title: Text(s.name),
            subtitle: Text(s.contribution),
            onTap: () => close(context, null),
          )),
        ],
        if (records.isNotEmpty) ...[
          _buildHeader(context, 'Health Records'),
          ...records.map((r) => ListTile(
            leading: const Icon(Icons.history),
            title: Text(r.condition),
            subtitle: Text('${r.dateLabel} - ${r.note}'),
            onTap: () => close(context, null),
          )),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
