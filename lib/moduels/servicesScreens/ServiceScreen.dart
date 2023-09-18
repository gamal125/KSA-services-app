import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/components/components.dart';
import 'package:services/model/UserModel.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../../model/servicemodel.dart';
import '../../shared/local/cache_helper.dart';
import '../chatsScreens/messageScreen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<ServiceModel> list = [];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getService();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetServiceSuccessState) {
          list = AppCubit.get(context).serviceList;
        }
        if (state is GetAllUsersSuccessStates) {
          if (AppCubit.get(context).onlineUsers.isNotEmpty) {
            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context)
                    .onlineUsers[getRandomNumber(
                        AppCubit.get(context).onlineUsers.length)]
                    .uId!);
          } else if (AppCubit.get(context).onlineUsers2.isNotEmpty) {
            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context)
                    .onlineUsers2[getRandomNumber(
                        AppCubit.get(context).onlineUsers2.length)]
                    .uId!);
            showToast(
                text: 'كل الموظفون  الان برجاء الانتظار',
                state: ToastStates.error);
          } else {
            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context)
                    .onlineUsers3[getRandomNumber(
                        AppCubit.get(context).onlineUsers3.length)]
                    .uId!);
            showToast(
                text: 'كل الموظفون مشغلون الان برجاء المحاوله لاحقا',
                state: ToastStates.error);
          }
        }

        if (state is GetMessageSuccessState) {
          UserModel? model;
          AppCubit.get(context).AllUsers.forEach((element) {
            if (element.uId == state.R_uId) {
              model = element;
            }
          });

          model != null
              ? navigateTo(
                  context,
                  MessageScreen(
                    R_userdata: model!,
                  ))
              : null;
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
              "خدمات عامه و إلكترونية",
              style:
                  TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
            )),
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15,
                childAspectRatio: 1 / 1.2,
                children: List.generate(
                    list.length, (index) => ServiceItems(list[index], context)),
              ),
            ),
          )),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
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

  Widget ServiceItems(ServiceModel model, context) => InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 24.0,
                    title: const Center(
                        child: Text(
                      'اختر النوع',
                      textAlign: TextAlign.right,
                    )),
                    content: const Text(
                      'هل تريد التحدث مع ذكر ام انثي؟',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                AppCubit.get(context).getusers(male: false);
                              },
                              child: Text('انثي')),
                          TextButton(
                              onPressed: () {
                                AppCubit.get(context).getusers(male: true);
                              },
                              child: Text('ذكر')),
                        ],
                      ),
                    ],
                  ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Card(
                color: KPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.none,
                elevation: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            model.name!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Dubai',
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          '${model.price!} \$',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Dubai',
                          ),
                        )))
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  int getRandomNumber(int length) {
    Random random = Random();
    return random.nextInt(length);
  }
}
