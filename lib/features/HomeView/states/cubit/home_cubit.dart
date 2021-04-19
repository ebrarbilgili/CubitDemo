import 'package:bloc/bloc.dart';
import 'package:bloc_state/features/HomeView/model/home_model.dart';
import 'package:bloc_state/features/HomeView/service/home_service.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;
  HomeCubit(this.homeService) : super(HomeInitial());

  Future<void> getHomeData() async {
    try {
      emit(HomeLoading());

      final response = await homeService.getHomeModel();

      emit(HomeCompleted(response));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
