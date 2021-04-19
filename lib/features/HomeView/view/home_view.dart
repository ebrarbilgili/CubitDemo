import 'package:bloc_state/features/HomeView/model/home_model.dart';
import 'package:bloc_state/features/HomeView/service/home_service.dart';
import 'package:bloc_state/features/HomeView/states/cubit/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => HomeCubit(
              HomeService(
                service: Dio(
                  BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
                ),
              ),
            ),
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is HomeInitial) {
              return buildHomeInitial(context);
            } else if (state is HomeLoading) {
              return buildHomeLoading(context);
            } else if (state is HomeCompleted) {
              return buildHomeCompleted(state, context);
            } else {
              final error = state as HomeError;
              return buildHomeError(error, context);
            }
          },
        ));
  }

  Scaffold buildHomeError(HomeError error, BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: Center(child: Text('${error.errorMessage}')),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Scaffold buildHomeCompleted(HomeCompleted state, BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      body: ListView.builder(
        itemCount: state.listHomeModel.length,
        itemBuilder: (BuildContext context, int index) {
          final data = state.listHomeModel[index];
          return buildCard(data);
        },
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Scaffold buildHomeLoading(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar,
        floatingActionButton: buildFloatingActionButton(context),
        body: Center(child: CircularProgressIndicator()));
  }

  Scaffold buildHomeInitial(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar,
      floatingActionButton: buildFloatingActionButton(context),
      body: Center(
        child: Text('Welcome Cubit State Management!'),
      ),
    );
  }

  Card buildCard(HomeModel data) {
    return Card(
      child: ListTile(
        leading: Text(data.id.toString()),
        title: Text(data.name ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${data.username}'),
            Text('Commpany: ${data.company}'),
            Text('Email: ${data.email}'),
            Text('Phone: ${data.phone}'),
            Text('City: ${data.address!.city}'),
          ],
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<HomeCubit>().getHomeData();
      },
      child: Icon(Icons.get_app_rounded),
    );
  }

  AppBar get buildAppBar => AppBar(title: Text('Bloc/Cubit State Management'));
}
