import 'package:flutter/material.dart';
import 'package:gheseh_shab/data/repositories/search_repository.dart';
import 'package:gheseh_shab/presentation/widgets/story_form.dart';
import 'package:gheseh_shab/data/models/story_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchRepository _searchRepository = SearchRepository();

  // فیلدهای فیلتر
  List<Map<String, dynamic>> collections = [];
  List<Map<String, dynamic>> speakers = [];
  List<String> types = [];
  List<String> authors = [];
  List<String> languages = [];

  // انتخاب‌های کاربر
  String? selectedCollection;
  String? selectedSpeaker;
  List<String> selectedTypes = [];
  List<String> selectedAuthors = [];
  List<String> selectedLanguages = [];

  // سرچ
  String searchText = '';

  // نتایج
  List<StoryModel> stories = [];

  // وضعیت
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFiltersAndSearch();
  }

  Future<void> _fetchFiltersAndSearch() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final filters = await _searchRepository.fetchFilters();
      setState(() {
        collections = List<Map<String, dynamic>>.from(filters['playlists']);
        speakers = List<Map<String, dynamic>>.from(filters['announcers']);
        types = List<String>.from(filters['type_of_works']);
        authors = List<String>.from(filters['authors'].map((e) => e['name']));
        languages = List<String>.from(filters['languages']);
      });
      await _searchStories();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'خطا در دریافت اطلاعات: $e';
      });
    }
  }

  Future<void> _searchStories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final results = await _searchRepository.searchStories(
        author: selectedAuthors.isNotEmpty ? selectedAuthors.first : null,
        announcer: selectedSpeaker, // name برای گوینده
        typeOfWork: selectedTypes.isNotEmpty ? selectedTypes.first : null,
        language: selectedLanguages.isNotEmpty ? selectedLanguages.first : null,
        playlists: selectedCollection, // id برای مجموعه
        search: searchText.isNotEmpty ? searchText : null,
      );
      setState(() {
        stories = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'خطا در جستجو: $e';
      });
    }
  }

  // فراخوانی این متد بعد از هر تغییر فیلتر یا سرچ
  void _onFilterChanged() {
    _searchStories();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBox(isDarkMode),
            const SizedBox(height: 16),
            _buildFilterTile(
              title: "مجموعه",
              selectedValues: selectedCollection != null
                  ? [
                      collections.firstWhere((e) =>
                          e['id'].toString() == selectedCollection)['name']
                    ]
                  : [],
              onTap: () => _showSingleSelectSheet(
                title: "مجموعه",
                options: collections,
                selectedItem: selectedCollection,
                onSelect: _onCollectionSelected,
              ),
            ),
            const SizedBox(height: 8),
            _buildFilterTile(
              title: "گوینده",
              selectedValues: selectedSpeaker != null ? [selectedSpeaker!] : [],
              onTap: () => _showSingleSelectSheet(
                title: "گوینده",
                options: speakers,
                selectedItem: selectedSpeaker,
                onSelect: _onSpeakerSelected,
              ),
            ),
            const SizedBox(height: 8),
            _buildFilterTile(
              title: "نوع اثر",
              selectedValues: selectedTypes,
              onTap: () => _showMultiSelectSheet(
                title: "نوع اثر",
                options: types,
                selectedItems: selectedTypes,
                onApply: _onTypesSelected,
              ),
            ),
            const SizedBox(height: 8),
            _buildFilterTile(
              title: "نویسنده",
              selectedValues: selectedAuthors,
              onTap: () => _showMultiSelectSheet(
                title: "نویسنده",
                options: authors,
                selectedItems: selectedAuthors,
                onApply: _onAuthorsSelected,
              ),
            ),
            const SizedBox(height: 8),
            _buildFilterTile(
              title: "زبان",
              selectedValues: selectedLanguages,
              onTap: () => _showMultiSelectSheet(
                title: "زبان",
                options: languages,
                selectedItems: selectedLanguages,
                onApply: _onLanguagesSelected,
              ),
            ),
            const SizedBox(height: 24),
            _buildStoriesSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(bool isDarkMode) {
    return TextField(
      onChanged: (val) {
        searchText = val;
        _onFilterChanged();
      },
      decoration: InputDecoration(
        hintText: "جستجو",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: isDarkMode ? Colors.blueGrey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterTile({
    required String title,
    required List<String> selectedValues,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedValues.isEmpty
                    ? "انتخاب $title"
                    : "$title: ${selectedValues.join(', ')}",
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection(bool isDarkMode) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    if (stories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('داستانی یافت نشد'),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1, // مربع شدن آیتم‌ها
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) => StoryCard(story: stories[index]),
    );
  }

  void _showMultiSelectSheet({
    required String title,
    required List<String> options,
    required List<String> selectedItems,
    required void Function(List<String>) onApply,
  }) {
    final tempSelected = List<String>.from(selectedItems);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Text(
                      "انتخاب $title",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView(
                      children: options.map((item) {
                        return CheckboxListTile(
                          title: Text(item),
                          value: tempSelected.contains(item),
                          onChanged: (checked) {
                            setModalState(() {
                              if (checked == true) {
                                tempSelected.add(item);
                              } else {
                                tempSelected.remove(item);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      onApply(tempSelected);
                      Navigator.pop(context);
                    },
                    child: const Text("اعمال تغییرات"),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSingleSelectSheet({
    required String title,
    required List options,
    required String? selectedItem,
    required void Function(String?) onSelect,
  }) {
    final isWithImage = title == "مجموعه" || title == "گوینده";
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        // اضافه کردن گزینه حذف انتخاب به ابتدای لیست
        final List allOptions = [
          {'id': null, 'name': 'حذف انتخاب', 'image': null},
          ...options
        ];
        return SizedBox(
          height: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Text(
                  "انتخاب $title",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: allOptions.length,
                  itemBuilder: (context, idx) {
                    final item = allOptions[idx];
                    final name = item['name'];
                    final id = item['id']?.toString();
                    final imageUrl = item['image'];
                    return RadioListTile<String>(
                      title: Row(
                        children: [
                          if (isWithImage)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: imageUrl != null
                                    ? NetworkImage(
                                        'https://qesseyeshab.ir$imageUrl')
                                    : null,
                                child: imageUrl == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                            ),
                          Expanded(child: Text(name)),
                        ],
                      ),
                      value: id.toString(),
                      groupValue: selectedItem,
                      onChanged: (val) {
                        // اگر مقدار انتخابی null بود، فیلتر حذف شود
                        onSelect(val == null || val == 'null' ? null : val);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _onCollectionSelected(String? id) {
    setState(() => selectedCollection = id); // id ذخیره شود
    _onFilterChanged();
  }

  void _onSpeakerSelected(String? val) {
    // name ذخیره شود
    final speaker = speakers.firstWhere(
      (e) => e['id'].toString() == val,
      orElse: () => {},
    );
    // ignore: unnecessary_null_comparison
    setState(() => selectedSpeaker = speaker != null ? speaker['name'] : null);
    _onFilterChanged();
  }

  void _onTypesSelected(List<String> val) {
    setState(() => selectedTypes = val);
    _onFilterChanged();
  }

  void _onAuthorsSelected(List<String> val) {
    setState(() => selectedAuthors = val);
    _onFilterChanged();
  }

  void _onLanguagesSelected(List<String> val) {
    setState(() => selectedLanguages = val);
    _onFilterChanged();
  }
}
