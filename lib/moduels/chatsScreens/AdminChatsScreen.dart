import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/chatsScreens/messageScreen.dart';

import '../../components/components.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';

class AdminChatsScreen extends StatefulWidget {
  const AdminChatsScreen({super.key});

  @override
  State<AdminChatsScreen> createState() => _AdminChatsScreenState();
}

class _AdminChatsScreenState extends State<AdminChatsScreen> {
  List<UserModel> model=[];

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built

  }

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {


        if(state is GetIdUsersChatsSuccessState){


            AppCubit.get(context).getAllUsersHaschats();


        }
        if(state is GetUsersHasChatsSuccessState){

          model=AppCubit.get(context).usersHasChats;
          print(model.length);
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return   Scaffold(
          body: SafeArea(
            child: ConditionalBuilder(
              condition: state is GetUsersHasChatsSuccessState,
              builder: (context) {
                return model.isNotEmpty?
                ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => catList(
                      model[index], context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: model.length,

                ):Center(child: Text('لا توجد دردشات'),);
              }, fallback: ( context) => Center(child: CircularProgressIndicator()) ,
            ),
          ),
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
        );


      },
    );

  }
  Widget catList(UserModel model, context) => InkWell(

    onTap: () {
      AppCubit.get(context).getmessages(R_uId: model.uId!);
      navigateTo(context, MessageScreen(R_userdata: model));


    },
    child: Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(''),



              ],
            ),
            Text(
              model.name!.toUpperCase(),
              style:TextStyle( fontWeight: FontWeight.bold,fontSize:12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                   shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image:  model.image!='' ?DecorationImage(
                      image:   NetworkImage(
                        model.image!,
                      ),
                      fit: BoxFit.scaleDown,
                    ):DecorationImage(image: AssetImage("assets/icon/1.jpg"),fit: BoxFit.fill),
                  ),
                ),
                Padding(
                  padding:  EdgeInsetsDirectional.only(bottom: 3.0,end: 3),
                  child: CircleAvatar(radius: 5,backgroundColor: model.state? Colors.green:Colors.grey,),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );

}
