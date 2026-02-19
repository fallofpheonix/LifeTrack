
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/core/state/store_provider.dart';

class MedicalDetailsSection extends ConsumerStatefulWidget {
  const MedicalDetailsSection({super.key});

  @override
  ConsumerState<MedicalDetailsSection> createState() => _MedicalDetailsSectionState();
}

class _MedicalDetailsSectionState extends ConsumerState<MedicalDetailsSection> {
  // Controllers
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationController;
  late TextEditingController _insuranceProviderController;
  late TextEditingController _insurancePolicyController;

  // Lists
  List<String> _medicalHistory = [];
  List<String> _allergies = [];

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final userProfile = ref.read(lifeTrackStoreProvider).userProfile;
    _initControllers(userProfile);
  }

  void _initControllers(UserProfile profile) {
    _emergencyNameController = TextEditingController(text: profile.emergencyContactName);
    _emergencyPhoneController = TextEditingController(text: profile.emergencyContactPhone);
    _emergencyRelationController = TextEditingController(text: profile.emergencyContactRelation);
    _insuranceProviderController = TextEditingController(text: profile.insuranceProvider);
    _insurancePolicyController = TextEditingController(text: profile.insurancePolicyNumber);
    
    _medicalHistory = List.from(profile.medicalHistory);
    _allergies = List.from(profile.allergies);
  }

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _insuranceProviderController.dispose();
    _insurancePolicyController.dispose();
    super.dispose();
  }

  void _save() {
    final store = ref.read(lifeTrackStoreProvider);
    final currentProfile = store.userProfile;

    final UserProfile newProfile = UserProfile(
      id: currentProfile.id,
      name: currentProfile.name,
      age: currentProfile.age,
      weight: currentProfile.weight,
      height: currentProfile.height,
      gender: currentProfile.gender,
      bloodType: currentProfile.bloodType,
      createdAt: currentProfile.createdAt,
      updatedAt: DateTime.now(),
      // New Fields
      medicalHistory: _medicalHistory,
      allergies: _allergies,
      emergencyContactName: _emergencyNameController.text.trim(),
      emergencyContactPhone: _emergencyPhoneController.text.trim(),
      emergencyContactRelation: _emergencyRelationController.text.trim(),
      insuranceProvider: _insuranceProviderController.text.trim(),
      insurancePolicyNumber: _insurancePolicyController.text.trim(),
    );

    // Update via store (we might need a dedicated update method if updateProfile expects exact args
    // but looking at store.updateProfile, it takes a whole UserProfile object)
    store.updateProfile(newProfile, store.snapshot.caloriesGoal);
    
    setState(() {
      _isEditing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medical details updated')));
  }

  void _addItem(List<String> list, String title) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter $title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  list.add(controller.text.trim());
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch for external updates
    final userProfile = ref.watch(lifeTrackStoreProvider).userProfile;
    // If not editing, sync state with store to ensure fresh data
    if (!_isEditing) {
       // We don't want to re-init full controllers every build, but for a simple form 
       // inside a complex page, we should ensure we show latest data if changed elsewhere.
       // For now, assume this is the primary edit point.
    }

    return BaseCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Medical Details', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  onPressed: () {
                    if (_isEditing) {
                      _save();
                    } else {
                      setState(() {
                        _isEditing = true;
                        _initControllers(userProfile); // Refresh from store on edit start
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildSectionHeader('Emergency Contact'),
            _buildTextField('Name', _emergencyNameController, Icons.person, enabled: _isEditing),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField('Phone', _emergencyPhoneController, Icons.phone, enabled: _isEditing)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Relation', _emergencyRelationController, Icons.people, enabled: _isEditing)),
              ],
            ),
            const Divider(height: 32),
            
            _buildSectionHeader('Insurance'),
            _buildTextField('Provider', _insuranceProviderController, Icons.health_and_safety, enabled: _isEditing),
             const SizedBox(height: 8),
            _buildTextField('Policy Number', _insurancePolicyController, Icons.numbers, enabled: _isEditing),
            const Divider(height: 32),

            _buildSectionHeader('Allergies', onAdd: _isEditing ? () => _addItem(_allergies, 'Allergy') : null),
            if (_allergies.isEmpty) const Text('No allergies listed.', style: TextStyle(color: Colors.grey)),
            Wrap(
              spacing: 8,
              children: _allergies.map((e) => Chip(
                label: Text(e),
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                deleteIcon: _isEditing ? const Icon(Icons.close, size: 18) : null,
                onDeleted: _isEditing ? () => setState(() => _allergies.remove(e)) : null,
              )).toList(),
            ),
             const Divider(height: 32),

            _buildSectionHeader('Medical History', onAdd: _isEditing ? () => _addItem(_medicalHistory, 'Condition') : null),
            if (_medicalHistory.isEmpty) const Text('No medical history listed.', style: TextStyle(color: Colors.grey)),
            ..._medicalHistory.map((e) => ListTile(
              leading: const Icon(Icons.history_edu, size: 20),
              title: Text(e),
              contentPadding: EdgeInsets.zero,
              trailing: _isEditing ? IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => setState(() => _medicalHistory.remove(e)),
              ) : null,
              visualDensity: VisualDensity.compact,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAdd}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (onAdd != null)
            InkWell(
              onTap: onAdd,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.add_circle, size: 20, color: Colors.indigo),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
    );
  }
}
