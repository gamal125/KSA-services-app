import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/components/components.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/model/servicemodel.dart';
import '../../Applocalizition.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../chatsScreens/messageScreen.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {

  var scaffoldkey = GlobalKey<ScaffoldState>();


  var formkey = GlobalKey<FormState>();
  List<ServiceModel> list=[];
  var titleController = TextEditingController();
  var priceController = TextEditingController();
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    list=AppCubit.get(context).serviceList;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {
        if(state is GetServiceLoadingState){
          list.clear();
        }
        if(state is GetServiceSuccessState){
          list=AppCubit.get(context).serviceList;
        }
        if(state is SetServiceSuccessState){
          AppCubit.get(context).getService();
          Navigator.pop(context);
        }

        if (state is GetAllUsersSuccessStates) {

          if(AppCubit.get(context).onlineUsers.isNotEmpty) {

            AppCubit.get(context).getmessages(R_uId: AppCubit
                .get(context)
                .onlineUsers[getRandomNumber(AppCubit.get(context).onlineUsers.length)].uId!,);
          }
          else if(AppCubit.get(context).onlineUsers2.isNotEmpty){
            AppCubit.get(context).getmessages(R_uId: AppCubit.get(context).onlineUsers2[getRandomNumber(AppCubit.get(context).onlineUsers2.length)].uId!, );
            showToast(text: 'كل الموظفون  الان برجاء الانتظار', state: ToastStates.error);
          }else{
            AppCubit.get(context).getmessages(R_uId: AppCubit.get(context).onlineUsers3[getRandomNumber(AppCubit.get(context).onlineUsers3.length)].uId!, );
            showToast(text: 'كل الموظفون مشغلون الان برجاء المحاوله لاحقا', state: ToastStates.error);

          }
        }

        if (state is GetMessageSuccessState) {
          UserModel? model;
          AppCubit.get(context).AllUsers.forEach((element) {
            if(element.uId==state.R_uId){
              model=element;
            }
          });

        model!=null? navigateTo(context, MessageScreen(R_userdata: model! ,)):null;

        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return   Scaffold(
          key: scaffoldkey,
          appBar: AppBar(title:  Center(child: Text(AppLocalizations.of(context)!.translate('services'),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),),
          body: SafeArea(
          child: SingleChildScrollView(
            child: ConditionalBuilder(
              condition: state is! GetServiceLoadingState&& state is! DeleteServiceLoadingState,
              builder:(context)=> Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 18),
                child: GridView.count(

                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  crossAxisCount: 3,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1 / 1.2,
                  children: List.generate(

                    list.length
                    ,(index) =>
                      ServiceItems(list[index], context)),
                  ),
              ), fallback: (BuildContext context) {return const Center(child: CircularProgressIndicator()); },
            ),
          )

          ),
          // floatingActionButton: FloatingActionButton(onPressed: () {  },backgroundColor: Colors.yellow,child: const Icon(Icons.add,color: Colors.black,),),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)
              )
              , boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            ),
            child: BottomNavigationBar(
              selectedIconTheme: const IconThemeData(color:Colors.green,),
              selectedItemColor: Colors.green,

              items: cubit.BottomItems,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },


            ),
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.yellow,
            onPressed: () {
              setState(() {
                if (cubit.isBottomSheetShown) {
                    if (formkey.currentState!.validate()) {
                       cubit.setService(name: titleController.text, price: priceController.text);
                       titleController.text='';
                       priceController.text='';
                    }

                } else {
                  scaffoldkey.currentState!.showBottomSheet((context) => Container(
                    color: AppCubit.get(context).isDark?Colors.black:Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return    AppLocalizations.of(context)!.translate('name1');
                              }
                              return null;
                            },
                            label:  AppLocalizations.of(context)!.translate('name2'),
                            prefix: Icons.title, tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                          ),
                          SizedBox(height: 10,),
                          defaultTextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return    AppLocalizations.of(context)!.translate('price');
                              }
                              return null;
                            },
                            label: AppLocalizations.of(context)!.translate('price2'),
                            prefix: Icons.title, tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                          ),

                        ],
                      ),
                    ),
                  )).closed.then((value) {    cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                  });
                }
                cubit.changeBottomSheetState(
                  isShow: !cubit.isBottomSheetShown,
                  icon: cubit.isBottomSheetShown ? Icons.edit : Icons.add,
                );
              });
            },
            child: Icon(
              cubit.fabIcon,
              color: Colors.black,
            ),
          ),

          // Bottom






              );


      },
    );

  }

  Widget ServiceItems(ServiceModel model,context)=> InkWell(
    onTap: () {


    },
    child: Container(

      decoration: BoxDecoration(    borderRadius: BorderRadius.circular(20),    boxShadow: [
        BoxShadow(
          color:   Colors.green.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],),
      child: Stack(
        children: [
          Card(

            color: Colors.green,
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
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Dubai',
                          color: Colors.white,
                        ),
                        textDirection: TextDirection.rtl,


                      ),
                    ),
                  ),
                ),
                Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.8),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20),) ), width: double.infinity,
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
          Positioned(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                  alignment: AlignmentDirectional.bottomCenter,
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 24.0,
                              title:  Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('delete'),
                                    textAlign: TextAlign.right,
                                  )),
                              content:  Text(
                                  AppLocalizations.of(context)!.translate('delete2'),
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.right,
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          AppCubit.get(context).deleteService(name: model.name!,);
                                        },
                                        child: Text( AppLocalizations.of(context)!.translate('yes'))),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text( AppLocalizations.of(context)!.translate('no'))),
                                  ],
                                ),
                              ],
                            ));

                    }, icon:Icon( Icons.delete,color: Colors.red,)),
            ),
          )
        ],
      ),

    ),
  );
  int getRandomNumber(int length) {
    Random random = Random();
    return random.nextInt(length);
  }
}
