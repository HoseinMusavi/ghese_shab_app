import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const PageChangedState(0)) {
    on<ChangePageEvent>((event, emit) {
      emit(PageChangedState(event.pageIndex)); // تغییر صفحه
    });
  }
}
