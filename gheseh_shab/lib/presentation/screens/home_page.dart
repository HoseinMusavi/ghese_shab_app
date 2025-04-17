import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gheseh_shab/data/models/story_model.dart';
import 'package:gheseh_shab/logic/category/category_bloc.dart';
import 'package:gheseh_shab/logic/category/category_event.dart';
import 'package:gheseh_shab/logic/category/category_state.dart';
import 'package:gheseh_shab/logic/story_bloc/story_bloc.dart';
import 'package:gheseh_shab/logic/story_bloc/story_event.dart';
import 'package:gheseh_shab/logic/story_bloc/story_state.dart';
import 'package:gheseh_shab/presentation/widgets/story_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();

    // ارسال ایونت برای دریافت دسته‌بندی‌ها
    context.read<CategoryBloc>().add(FetchCategoriesEvent());

    // ارسال ایونت اولیه برای دریافت استوری‌ها
    context.read<StoryBloc>().add(FetchStoriesEvent());

    // Listener برای جستجو
    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.trim();
    final selectedCategory = _selectedCategoryIndex == 0
        ? null // تب "همه" مقدار فیلتر را null تنظیم می‌کند
        : context.read<CategoryBloc>().state is CategoryLoaded
            ? (context.read<CategoryBloc>().state as CategoryLoaded)
                .categories[_selectedCategoryIndex - 1]
                .id
                .toString()
            : null;

    context.read<StoryBloc>().add(
          UpdateStoriesEvent(
            search: searchQuery,
            filter: selectedCategory,
          ),
        );
  }

  void _onCategorySelected(int index) {
    if (_selectedCategoryIndex == index) return; // جلوگیری از بازسازی غیرضروری

    setState(() {
      _selectedCategoryIndex = index;
    });

    final searchQuery = _searchController.text.trim();
    final selectedCategory = index == 0
        ? null // تب "همه" مقدار فیلتر را null تنظیم می‌کند
        : context.read<CategoryBloc>().state is CategoryLoaded
            ? (context.read<CategoryBloc>().state as CategoryLoaded)
                .categories[index - 1]
                .id
                .toString()
            : null;

    context.read<StoryBloc>().add(
          UpdateStoriesEvent(
            search: searchQuery,
            filter: selectedCategory,
          ),
        );

    // تغییر صفحه در PageView
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _refreshStories() async {
    final searchQuery = _searchController.text.trim();
    final selectedCategory = _selectedCategoryIndex == 0
        ? null
        : context.read<CategoryBloc>().state is CategoryLoaded
            ? (context.read<CategoryBloc>().state as CategoryLoaded)
                .categories[_selectedCategoryIndex - 1]
                .id
                .toString()
            : null;

    context.read<StoryBloc>().add(
          FetchStoriesEvent(
            search: searchQuery,
            filter: selectedCategory,
          ),
        );
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
          childAspectRatio: 1,
        ),
        itemCount: stories.length,
        cacheExtent: 1000,
        itemBuilder: (context, index) => StoryCard(story: stories[index]),
      ),
    );
  }

  Widget _buildCategoryList() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          final categories = ["همه", ...state.categories.map((e) => e.name)];

          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedCategoryIndex;
                return GestureDetector(
                  onTap: () => _onCategorySelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        categories[index],
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
        } else if (state is CategoryError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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

                // ارسال ایونت برای به‌روزرسانی استوری‌ها
                final searchQuery = _searchController.text.trim();
                final selectedCategory = index == 0
                    ? null // تب "همه" مقدار فیلتر را null تنظیم می‌کند
                    : context.read<CategoryBloc>().state is CategoryLoaded
                        ? (context.read<CategoryBloc>().state as CategoryLoaded)
                            .categories[index - 1]
                            .id
                            .toString()
                        : null;

                context.read<StoryBloc>().add(
                      UpdateStoriesEvent(
                        search: searchQuery,
                        filter: selectedCategory,
                      ),
                    );
              },
              itemCount: context.read<CategoryBloc>().state is CategoryLoaded
                  ? (context.read<CategoryBloc>().state as CategoryLoaded)
                          .categories
                          .length +
                      1
                  : 1, // تب "همه" + تعداد دسته‌بندی‌ها
              itemBuilder: (context, index) {
                return RefreshIndicator(
                  onRefresh: _refreshStories,
                  child: BlocBuilder<StoryBloc, StoryState>(
                    builder: (context, state) {
                      if (state is StoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is StoryLoaded) {
                        final size = MediaQuery.of(context).size;
                        return _buildStoryGrid(state.stories, size);
                      } else if (state is StoryError) {
                        return Center(
                          child: Text(
                            state.message,
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
