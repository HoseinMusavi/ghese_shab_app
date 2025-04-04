import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/logic/story_bloc/story_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/logic/story_bloc/story_state.dart';
import 'package:gheseh_shab/main.dart';
import 'package:gheseh_shab/presentation/widgets/story_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    "همه",
    "محبوب‌ترین",
    "داستان خارجی",
    "داستان ایرانی"
  ];

  @override
  void initState() {
    super.initState();
    if (context.read<StoryBloc>().state is StoryInitial) {
      context.read<StoryBloc>().add(FetchStoriesEvent());
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget _buildSearchField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          hintText: "جستجو",
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white54 : Colors.black54,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildStoryGrid(List<StoryModel> stories, Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1, // مربع کردن تصاویر
        ),
        itemCount: stories.length,
        cacheExtent: 1000, // بهینه‌سازی برای بارگذاری
        itemBuilder: (context, index) => StoryCard(story: stories[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صفحه اصلی",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'dana',
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode
            ? const Color(0xFF0E2A3A)
            : const Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              final themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              MyApp.of(context).setThemeMode(themeMode);
              setState(() {}); // Update the UI to reflect the theme change
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          const SizedBox(height: 10),
          _buildCategoryList(),
          const SizedBox(height: 10),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final size = MediaQuery.of(context).size;
                return BlocBuilder<StoryBloc, Story_State>(
                  builder: (context, state) {
                    if (state is StoryLoding) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StoryLoded) {
                      final filteredStories = state.storyList.where((story) {
                        if (index == 0) return true; // "همه"
                        if (index == 1)
                          return story.isPopular == true; // "محبوب‌ترین"
                        if (index == 2)
                          return story.isForeign == true; // "داستان خارجی"
                        if (index == 3)
                          return story.isIranian == true; // "داستان ایرانی"
                        return false;
                      }).toList();
                      return _buildStoryGrid(filteredStories, size);
                    } else if (state is StoryError) {
                      return Center(
                        child: Text(
                          state.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontFamily: 'dana',
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        "برای دریافت داستان‌ها، لطفاً صفحه را کشیده و بارگذاری کنید.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'dana',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () => _onCategorySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDarkMode ? Colors.blueAccent : Colors.deepPurple)
                    : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDarkMode
                                  ? Colors.blueAccent
                                  : Colors.deepPurple)
                              .withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDarkMode ? Colors.white70 : Colors.black87),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
