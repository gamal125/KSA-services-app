import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/layout/todo_layout.dart';
import 'package:services/model/UserModel.dart';

import '../../../Applocalizition.dart';
import '../../../components/components.dart';
import '../../../core/constance/constants.dart';
import '../../../cubit/AppCubit.dart';
import '../../../cubit/states.dart';
import 'AdminmessageScreen.dart';

class AdminCustomerServicesScreen extends StatefulWidget {
  const AdminCustomerServicesScreen({super.key});

  @override
  State<AdminCustomerServicesScreen> createState() => _AdminCustomerServicesScreenState();
}

class _AdminCustomerServicesScreenState extends State<AdminCustomerServicesScreen> {
  List<UserModel> model=[];

  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
model=AppCubit.get(context).customerSevice;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {

        },
      builder: (context, state) {
        return   Scaffold(
          appBar: AppBar(
            title: Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('chats'),
                  style:
                  const TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
                )),
            leading: IconButton(onPressed: (){AppCubit.get(context).changeIndex(1); navigateAndFinish(context, Home_Layout());},icon:  Icon(CupertinoIcons.back,color: AppCubit.get(context).isDark?Colors.white:Colors.black),),
            elevation: 0,
          ),
          body: ConditionalBuilder(
            condition: true,
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

              ):Center(child: Text(AppLocalizations.of(context)!.translate('No items'),style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),),);
            }, fallback: ( context) => Center(
              child: LoadingAnimationWidget.inkDrop(
                color: KPrimaryColor.withOpacity(.8),
                size: screenSize.width / 12,
              )) ,
          ),

        );


      },
    );

  }
  Widget catList(UserModel model, context) => InkWell(

    onTap: () async {
      AppCubit.get(context).getarmessages(R_uId: model.uId!);
      navigateTo(context, AdminMessageScreen(rUserdata: model, name: model.name!,));







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
