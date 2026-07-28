import 'package:flutter/material.dart';
import 'medication.dart';
import 'mock_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DINARA VET',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MedicationDirectoryScreen(),
    );
  }
}

class MedicationDirectoryScreen extends StatefulWidget {
  const MedicationDirectoryScreen({super.key});

  @override
  State<MedicationDirectoryScreen> createState() => _MedicationDirectoryScreenState();
}

class _MedicationDirectoryScreenState extends State<MedicationDirectoryScreen> {
  final List<Medication> _medications = mockMedications;
  List<Medication> _filteredMedications = mockMedications;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterMedications);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMedications() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedications = _medications.where((medication) {
        return medication.name.toLowerCase().contains(query) ||
            medication.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DINARA VET - Справочник'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Поиск препарата',
                hintText: 'Введите название или описание',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _filteredMedications.isEmpty
                ? const Center(child: Text('Ничего не найдено'))
                : ListView.builder(
                    itemCount: _filteredMedications.length,
                    itemBuilder: (context, index) {
                      final medication = _filteredMedications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(
                            medication.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            medication.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicationDetailScreen(medication: medication),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medication.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B3B5C), // Dark blue as in the image
                  ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9), // Light gray background
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                medication.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF333333),
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
