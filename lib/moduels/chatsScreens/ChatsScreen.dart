import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/chatsScreens/messageScreen.dart';
import '../../Applocalizition.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<UserModel> model=[];

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    model=AppCubit.get(context).usersHasChats;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {


        if(state is GetIdUsersChatsSuccessState){


            AppCubit.get(context).getAllUsersHaschats();


        }
        if(state is GetUsersHasChatsSuccessState){


          model=AppCubit.get(context).usersHasChats;


        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return   Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('chats'),
                  style:
                  const TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
                )),

          ),
          body: ConditionalBuilder(
            condition: state is GetUsersHasChatsSuccessState||state is GetPriceMessageSuccessState,
            builder: (context) {
              return model.isNotEmpty?
              ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  children: [
                    catList(
                        model[index], context),
                    myDivider()
                  ],
                ),
                separatorBuilder: (context, index) => myDivider(),
                itemCount: model.length,

              ):Center(child: Text(AppLocalizations.of(context)!.translate('No items')),);
            }, fallback: ( context) => Center(
              child: LoadingAnimationWidget.inkDrop(
                color: KPrimaryColor.withOpacity(.8),
                size: screenSize.width / 12,
              )) ,
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
              selectedIconTheme: const IconThemeData(color:KPrimaryColor,),
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
  Widget catList(UserModel model, context) => InkWell(

    onTap: () {
      AppCubit.get(context).getmessages(R_uId: model.uId!, );
      navigateTo(context, MessageScreen(R_userdata: model,));


    },
    child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(''),



              ],
            ),
            Text(
              model.name!.toUpperCase(),
              style: TextStyle( fontWeight: FontWeight.bold,fontSize:12,color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
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
                    ):const DecorationImage(image: AssetImage("assets/icon/1.jpg"),fit: BoxFit.fill),
                  ),
                ),
                Padding(
                  padding:  const EdgeInsetsDirectional.only(bottom: 3.0,end: 3),
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
