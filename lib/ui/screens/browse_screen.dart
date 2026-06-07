import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
import '../../models/scheme.dart';
import '../widgets/scheme_card.dart';
import 'detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Scheme> _schemes = [];
  List<Scheme> _filtered = [];
  Set<String> _categories = {};
  String? _selectedCategory;
  final _searchController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSchemes() async {
    final repo = Provider.of<SchemeRepository>(context, listen: false);
    final schemes = await repo.getAllSchemes();
    final cats = schemes.map((s) => s.category).toSet().toList()..sort();
    if (!mounted) return;
    setState(() {
      _schemes = schemes;
      _filtered = schemes;
      _categories = cats.toSet();
      _loading = false;
    });
  }

  void _filter(String query) {
    setState(() {
      _filtered = _schemes.where((s) {
        final matchesSearch = query.isEmpty ||
            s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.description.toLowerCase().contains(query.toLowerCase());
        final matchesCategory = _selectedCategory == null ||
            s.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सभी योजनाएं'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'योजना खोजें...',
                    prefixIcon: const Icon(Icons.search, size: 22),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _filter('');
                            },
                          )
                        : null,
                  ),
                  onChanged: _filter,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip(null, 'सभी'),
                      ..._categories.map(
                          (c) => _buildCategoryChip(c, c)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text('कोई योजना नहीं मिली'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final scheme = _filtered[index];
                    return SchemeCard(
                      scheme: scheme,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(
                              result: EligibilityResult(
                                scheme: scheme,
                                matchPercentage: 0,
                                matchedRules: [],
                                missedRules: [],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildCategoryChip(String? category, String label) {
    final isSelected = _selectedCategory == category;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = isSelected ? null : category);
          _filter(_searchController.text);
        },
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        side: BorderSide.none,
      ),
    );
  }
}
