import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/profileScreens/updateprofile.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../core/constance/constants.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../../login/login_screen.dart';
import '../../shared/local/cache_helper.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _switchValue = false;
  var isChecked = false;
  List<bool> _switchValues = [];
  List<bool> _switchValues2 = [];
  List<UserModel> list = [];
  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    cubit.getAllusers();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetAllUsersSuccessState) {
          list = [];
          list = AppCubit.get(context).users;
          list.forEach((element) {
            _switchValues2.add(element.male);
            _switchValues.add(element.user);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
                child: Text(
              "كل الموظفين",
              style:
                  TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
            )),
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            backgroundColor: Colors.white,
          ),
          body: ConditionalBuilder(
            builder: (context) => list.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsetsDirectional.only(start: 10.0, top: 10),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        UsersList(list[index], index, context),
                    separatorBuilder: (context, index) => SizedBox(
                      width: 10.0,
                    ),
                    itemCount: AppCubit.get(context).users.length,
                  )
                : const Center(child: Text('no users yet')),
            condition: state is! GetAllUsersLoadingState &&
                state is! AppChangeBottomNavBarState,
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: KPrimaryColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              selectedIconTheme: const IconThemeData(
                color: KPrimaryColor,
              ),
              selectedItemColor: KPrimaryColor,
              items: cubit.BottomItems,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget UsersList(UserModel model, int i, context) => Card(
        color: Colors.green.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.none,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  model.image != ''
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(model.image!),
                          radius: 40,
                        )
                      : const CircleAvatar(
                          backgroundImage: AssetImage('assets/icon/1.jpg'),
                          radius: 40,
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(model.name!),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      _switchValues[i]
                          ? Text(
                              'عميل',
                              style: TextStyle(
                                fontSize: 22,
                                color: KPrimaryColor,
                              ),
                            )
                          : Text(
                              'موظف',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.grey),
                            ),
                      Switch(
                        value: _switchValues[i],
                        onChanged: (value) {
                          setState(() {
                            _switchValues[i] = value;

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(model.uId)
                                .update({'user': _switchValues[i]});
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _switchValues2[i]
                          ? const Text(
                              'male',
                              style: TextStyle(
                                fontSize: 22,
                                color: KPrimaryColor,
                              ),
                            )
                          : const Text(
                              'female',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.grey),
                            ),
                      Switch(
                        value: _switchValues2[i],
                        onChanged: (value) {
                          setState(() {
                            _switchValues2[i] = value;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(model.uId)
                                .update({'male': _switchValues2[i]});
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
