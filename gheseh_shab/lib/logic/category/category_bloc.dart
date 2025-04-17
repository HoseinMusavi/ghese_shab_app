import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gheseh_shab/data/models/categories_model.dart';
import 'package:gheseh_shab/data/repositories/category_repository.dart';
import 'package:gheseh_shab/logic/category/category_event.dart';
import 'package:gheseh_shab/logic/category/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
      FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryRepository.fetchCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
