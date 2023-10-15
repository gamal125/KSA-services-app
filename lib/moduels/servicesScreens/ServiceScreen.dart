import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/components/components.dart';
import 'package:services/model/UserModel.dart';
import '../../Applocalizition.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../../model/servicemodel.dart';
import '../chatsScreens/messageScreen.dart';

class ServicesScreen extends StatefulWidget {
    ServicesScreen({super.key});
   String price='';
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
    list=AppCubit.get(context).serviceList;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetServiceLoadingState) {

        }
        if (state is GetServiceSuccessState) {

          list.toSet().toList();
          list = AppCubit.get(context).serviceList;
        }
        if (state is GetAllUsersSuccessStates) {
          if (AppCubit.get(context).onlineUsers.isNotEmpty) {

            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context)
                    .onlineUsers[getRandomNumber(
                        AppCubit.get(context).onlineUsers.length)]
                    .uId!, );
          } else if (AppCubit.get(context).onlineUsers2.isNotEmpty) {
            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context)
                    .onlineUsers2[getRandomNumber(
                        AppCubit.get(context).onlineUsers2.length)]
                    .uId!, );
            showToast(
                text: AppLocalizations.of(context)!.translate('cond1'),
                state: ToastStates.error);
          } else if(AppCubit.get(context).onlineUsers3.isNotEmpty) {

            AppCubit.get(context).getmessages(
                R_uId: AppCubit.get(context).onlineUsers3[getRandomNumber(AppCubit.get(context).onlineUsers3.length)]
                    .uId!, );
            showToast(
                text: AppLocalizations.of(context)!.translate('cond1'),
                state: ToastStates.error);
          }else{
            Navigator.pop(context);
            showToast(
                text: AppLocalizations.of(context)!.translate('cond2'),
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
         if( model != null ){
           print(widget.price);

           navigateTo(context, MessageScreen(R_userdata: model!,));}

        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('services'),
              style:
                  TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
            )),

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
                    list.length, (index) => ServiceItems(list[index],context)),
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

  Widget ServiceItems(ServiceModel model, context) =>InkWell(
        onTap: () {
          AppCubit.get(context).userdata!.user?   showDialog(context: context, builder: (context) =>
                  AlertDialog(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 24.0,
                    title:  Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate('select type'),
                      textAlign: TextAlign.right,
                    )),
                    content:  Text(
                      AppLocalizations.of(context)!.translate('select type2')
                      ,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.price=model.price!;
                                });
                                AppCubit.get(context).getusers(male: false,);
                              },
                              child: Text( AppLocalizations.of(context)!.translate('female'))),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.price=model.price!;
                                });
                                AppCubit.get(context).getusers(male: true,);
                              },
                              child: Text(AppLocalizations.of(context)!.translate('male'))),
                        ],
                      ),
                    ],
                  )):null;
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
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.normal,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'ريال',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Dubai',
                                  ),
                                ),
                                Text(
                          '${model.price!}',
                          style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Dubai',
                          ),
                        ),
                              ],
                            )
                        ))
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
