import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/model/UserModel.dart';

import '../../Applocalizition.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import 'complaintMessages.dart';


class AdminComplaintChatsScreen extends StatefulWidget {
  const AdminComplaintChatsScreen({super.key});

  @override
  State<AdminComplaintChatsScreen> createState() => _AdminComplaintChatsScreenState();
}

class _AdminComplaintChatsScreenState extends State<AdminComplaintChatsScreen> {
  List<UserModel> model=[];

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {

if(state is GetComplaintUsersSuccessState){
  AppCubit.get(context).getComplaintUsers();
}

        if(state is GetComplaintUsersSuccessState2){

          model.clear();
          print(AppCubit.get(context).ComplaintIds.length);
          AppCubit.get(context).UsersComplaint.forEach((element) {

              model.add(element);


        });
          print(model.length);
      }
        },
      builder: (context, state) {
        return   Scaffold(
          appBar: AppBar(
            title:    Text(
              AppLocalizations.of(context)!.translate('Complaints'),
              style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
            ),
          ),

          body: SafeArea(
            child: ConditionalBuilder(
              condition: state is GetComplaintUsersSuccessState2,
              builder: (context) {
                return model.isNotEmpty?
                Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => catList(
                          model[index], context),
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount: model.length,

                    ),
                    myDivider()
                  ],
                ):Center(child: Text(AppLocalizations.of(context)!.translate('No itemsm')),);
              }, fallback: ( context) => Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: KPrimaryColor.withOpacity(.8),
                  size: screenSize.width / 12,
                )) ,
            ),
          ),

        );


      },
    );

  }
  Widget catList(UserModel model, context) => InkWell(

    onTap: () async {
AppCubit.get(context).getcomplaintMessage(R_uId: model.uId!);
navigateTo(context, AdminComplaintMessageScreen(R_userdata: model, name: model.name!,));







    },
    child: Container(
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
              style: TextStyle( fontWeight: FontWeight.bold,fontSize:12,color: AppCubit.get(context).isDark?Colors.white:Colors.black),
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
