import 'package:flutter/material.dart';
import 'package:flutter_multiplatformtest_app/model/user.dart';
import 'package:flutter_multiplatformtest_app/state_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserTitles {
  Name,
  Birthday,
  Country,
  Phone,
  Password,
  Picture,
  Latitude,
  Longitude,
}

class GridPhoto extends ConsumerWidget {
  Object? get users => null;

  final gridMaxJudgeProvider = StateProvider((ref) => true);
  final gridMinJudgeProvider = StateProvider((ref) => true);
  final selectAxisProvider = StateProvider((ref) => 3);

  List userData = [];

  get length => null;

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<User>> users = watch(userStateFuture);

    // final page = watch(pageProvider).state;
    final ScrollController _scrollController = new ScrollController();
    _scrollController.addListener(() async {
      if (_scrollController.position.maxScrollExtent <=
          _scrollController.position.pixels) {
        // await context.refresh(userStateFuture);
        context.read(countGridProvider).state = userData.length;
      }
    });
// final gridJudgeProvider = StateProvider((ref) => )
    final gridMaxJudge = watch(gridMaxJudgeProvider).state;
    final gridMinJudge = watch(gridMinJudgeProvider).state;
    final selectAxis = watch(selectAxisProvider).state;

    // late int countGrid = watch(countGridProvider).state;

    return Scaffold(
      appBar: AppBar(
        title: Text('GridView'),
        actions: <Widget>[
          IconButton(
            onPressed: !gridMaxJudge
                ? null
                : () {
                    ++context.read(selectAxisProvider).state;
                    context.read(gridMinJudgeProvider).state = true;
                    if (selectAxis == 9) {
                      context.read(gridMaxJudgeProvider).state = false;
                    }
                  },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: !gridMinJudge
                // ignore: dead_code
                ? null
                : () {
                    --context.read(selectAxisProvider).state;
                    context.read(gridMaxJudgeProvider).state = true;
                    if (selectAxis == 2) {
                      context.read(gridMinJudgeProvider).state = false;
                    }
                  },
            icon: Icon(Icons.remove),
          )
        ],
      ),
      body: users.when(
        data: (value) {
          listIn() {
            context.refresh(userStateFuture);

            for (int i = 0; i < value.length; i++) {
              Map<UserTitles, dynamic> userProfile = {
                UserTitles.Name: value[i].name?.fullname ?? 'None',
                UserTitles.Birthday: value[i].dob?.birthday ?? 'None',
                UserTitles.Country: value[i].location?.country ?? 'None',
                UserTitles.Phone: value[i].phone ?? 'None',
                UserTitles.Password: value[i].login?.password ?? 'None',
                UserTitles.Picture: value[i].picture?.large ?? 'None',
                UserTitles.Latitude:
                    value[i].location?.coordinates.latitude ?? 'None',
                UserTitles.Longitude:
                    value[i].location?.coordinates.longitude ?? 'None',
              };
              userData.add(userProfile);
            }
            countPage++;
          }

          listIn();

          return Center(
            child: RefreshIndicator(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: selectAxis,
                ),
                itemCount: userData.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == userData.length) {
                    listIn();
                  }
                  return GestureDetector(
                      onTap: () {
                        // context.read(countProvider).state = UserTitles.Name;

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             UserProfile(userData, index)));
                      },
                      child: Widget_photoItem(
                          userData[index][UserTitles.Picture]));
                },
              ),
              onRefresh: () async {
                await context.refresh(userStateFuture);
                userData.clear();
                listIn();
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('${error.toString()}'),
        ),
      ),
    );
  }

  // Future<void> reload(BuildContext context) async {}
}

Widget_photoItem(dynamic pictureKey) {
  return Container(
    constraints: BoxConstraints.expand(),
    child: Image.network(
      pictureKey,
      fit: BoxFit.contain,
    ),
  );
}
