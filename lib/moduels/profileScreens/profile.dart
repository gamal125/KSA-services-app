import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/moduels/profileScreens/WalletScreen.dart';
import 'package:services/moduels/profileScreens/updateprofile.dart';
import '../../Applocalizition.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../../login/login_screen.dart';
import '../../shared/local/cache_helper.dart';
import '../chatsScreens/complaintMessageScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
 if (state is GetUserWalletSuccessStates){
   navigateTo(context, WalletScreen(model:state.model));
 }
        if (state is LogoutSuccessState) {
          String uid = CacheHelper.getData(key: 'uId');
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'state': false});
          CacheHelper.saveData(key: 'uId', value: '');
          AppCubit.get(context).ud = '';
          AppCubit.get(context).currentIndex = 0;
          navigateAndFinish(context, LoginScreen());
        }
      },
      builder: (context, state) {
        return CacheHelper.getData(key: 'uId') == null ||
                CacheHelper.getData(key: 'uId') == '' ||
                AppCubit.get(context).userdata == null
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: KPrimaryColor,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              KPrimaryColor,
                              Colors.white, // Second color (bottom half)
                            ],
                            stops: [
                              0.2,
                              0.2
                            ], // Set the stops to create a sharp transition between the colors
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 72.0),
                              child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/icon/1.jpg'),
                                      radius: 60,
                                    ),
                                  ]),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                'new user',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const  Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                '******gmail.com',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                            ),
                            const  Padding(
                              padding:
                                  EdgeInsets.only(top: 10.0, bottom: 14),
                              child: Text(
                                '************',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                            ),
                            myDivider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, right: 20, left: 20, bottom: 10),
                              child: Container(
                                  height: 43,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ConditionalBuilder(
                                        condition: state is! LogoutLoadingState,
                                        builder: (context) => TextButton(
                                          onPressed: () {
                                            navigateTo(context, LoginScreen());
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!.translate('login'),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        fallback: (context) => Center(
                                            child: LoadingAnimationWidget.inkDrop(
                                              color: KPrimaryColor.withOpacity(.8),
                                              size: screenSize.width / 12,
                                            )) ,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                          child:const Icon(Icons.logout_rounded,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
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
              )
            : Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  actions: [
               IconButton(onPressed: (){AppCubit.get(context).changemode();}, icon: Icon(Icons.brightness_medium,color: AppCubit.get(context).isDark?Colors.white:Colors.black,)),
                   Spacer(),
                   CacheHelper.getData(key: 'uId')!='8DxVS7sTApPRE3oD1SZvLEjHXNg1' ?TextButton(
                      onPressed: () {

                        navigateTo(context, const ComplaintMessageScreen(R_id: '8DxVS7sTApPRE3oD1SZvLEjHXNg1',));
                      },
                      child:  Row(
                        children: [

                          Text(AppLocalizations.of(context)!.translate('Complaints'),style: const TextStyle(fontSize: 16,color: Colors.red),),
                          const Icon(Icons.list_alt,color: Colors.red,),
                        ],
                      )
                  ):const Text(''),],

                ),
                body: ConditionalBuilder(
                  builder: (context) => Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                KPrimaryColor,
                                Colors.transparent // Second color (bottom half)
                              ],
                              stops: [
                                0.2,
                                0.2
                              ], // Set the stops to create a sharp transition between the colors
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 72.0),
                                child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      AppCubit.get(context).userdata!.image ==
                                                  '' ||
                                              AppCubit.get(context)
                                                      .userdata!
                                                      .image ==
                                                  null
                                          ? const CircleAvatar(
                                              radius: 67,
                                              backgroundColor: Colors.white,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: AssetImage(
                                                    'assets/images/user.png'),
                                                radius: 60,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  AppCubit.get(context).userdata!.image!),
                                              radius: 60,
                                            ),
                                      Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: Center(
                                            child: IconButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  navigateTo(context,
                                                      UpdateProfileScreen());
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: KPrimaryColor,
                                                  size: 18,
                                                )),
                                          )),
                                    ]),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  AppCubit.get(context).userdata!.name!,
                                  style:  TextStyle(
                                      color: AppCubit.get(context).isDark?Colors.white:Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  AppCubit.get(context).userdata!.email!,
                                  style:  TextStyle(
                                      color: AppCubit.get(context).isDark?Colors.white:Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 14),
                                child: Text(
                                  AppCubit.get(context).userdata!.phone!,
                                  style:  TextStyle(
                                    color: AppCubit.get(context).isDark?Colors.white:Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18),
                                ),
                              ),
                             const SizedBox(height: 30,),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, right: 20, left: 20, bottom: 10),
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConditionalBuilder(
                                          condition: true,
                                          //state is! LogOutLoadingState,
                                          builder: (context) => TextButton(
                                            onPressed: () {
                                              AppCubit.get(context).getWalletUser(CacheHelper.getData(key: 'uId'));
                                            },
                                            child:  Text(
                                              AppLocalizations.of(context)!.translate('wallet'),
                                              style:  TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                            ),
                                          ),
                                          fallback: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey
                                                    .withOpacity(0.2)),
                                            child:  Icon(Icons.wallet,
                                              color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, right: 20, left: 20, bottom: 10),
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ConditionalBuilder(
                                          condition: true,
                                          //state is! LogOutLoadingState,
                                          builder: (context) => TextButton(
                                            onPressed: () {
                                              AppCubit.get(context).signout();
                                            },
                                            child:  Text(
                                              AppLocalizations.of(context)!.translate('logout'),
                                              style:  TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                            ),
                                          ),
                                          fallback: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.grey
                                                    .withOpacity(0.2)),
                                            child:  Icon(Icons.logout_rounded,
                                              color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  condition: state is! GetUsersInitStates &&
                      state is! AppChangeBottomNavBarState && state is! GetUserswalletStates ,
                  fallback: (context) =>
                      Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: KPrimaryColor.withOpacity(.8),
                            size: screenSize.width / 12,
                          )) ,
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
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
}
