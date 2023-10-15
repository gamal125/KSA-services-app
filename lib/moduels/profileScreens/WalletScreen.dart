import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/core/constance/constants.dart';
import 'package:services/core/widgets.dart';
import 'package:services/model/UserModel.dart';

import '../../Applocalizition.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';

class WalletScreen extends StatefulWidget {
   WalletScreen({super.key,required  this.model});
  UserModel model;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {


  @override

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
   if(state is SetUserBonusSuccessStates){
          setState(() {
           widget.model.bonus=state.bonus;
           widget.model.cash=state.cash;

          });


              }
        },
         builder: (context, state) {
          return Scaffold(
           appBar: AppBar(
             title: Center(child: Text(AppLocalizations.of(context)!.translate('wallet'),style: TextStyle(fontSize: 20,color: AppCubit.get(context).isDark?Colors.white:Colors.black,),))
           ),
            body:  ConditionalBuilder(
              condition:  state is! SetUserBonusLoadingStates,
              fallback: (context)=> Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: KPrimaryColor.withOpacity(.8),
                    size: screenSize.width / 12,
                  )),
              builder:(context)=> Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: screenSize.height*0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                      color: KPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(children: [
                      Expanded(child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/coins.png"))),)),
                       Expanded(child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                           Icon(Icons.star,color: Colors.yellow,size: screenSize.width*.08,),
                           SizedBox(width: 5,),
                           Text('نقاطك',style: TextStyle(fontSize: screenSize.width*.05),),
                         ],),
                           Text(widget.model.bonus.toString(),style: TextStyle(fontSize: screenSize.width*.05),),
                           Text("=",style: TextStyle(fontSize: screenSize.width*.05),),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text("ريال",style: TextStyle(fontSize: screenSize.width*.03,color: Colors.yellow),),
                               SizedBox(width: 15,),
                               Text((widget.model.bonus/1000).toString(),style: TextStyle(fontSize: screenSize.width*.05),),
                             ],
                           ),
                       ],))
                    ],),
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: screenSize.height*0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: KPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Container(
                    width: screenSize.width*0.25,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),

                     child: TextButton(onPressed: (){
                       if(widget.model.bonus>1000){
                       AppCubit.get(context).setBonus(cash: widget.model.cash, uId: widget.model.uId!, bonus:widget.model.bonus/1000);}else{
                         showToast(text: 'لايمكن سحب اقل من 1 ريال', state: ToastState.ERROR);}
                     }, child: Text('سحب',style: TextStyle(color: Colors.black,fontSize: screenSize.width*0.04),))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ريال",style: TextStyle(fontSize: screenSize.width*.03,color: Colors.yellow),),
                        SizedBox(width: 15,),
                        Text((widget.model.bonus/1000).toString(),style: TextStyle(fontSize: screenSize.width*.05),),
                      ],
                    ),

                ],),
                ),

              ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: screenSize.height*0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: KPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(children: [
                        Expanded(child: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/money.png"))),)),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.monetization_on,color: Colors.yellow,size: screenSize.width*.08,),
                                SizedBox(width: 10,),
                                Text('رصيدك',style: TextStyle(fontSize: screenSize.width*.05),),
                              ],),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("ريال",style: TextStyle(fontSize: screenSize.width*.04,color: Colors.yellow),),
                                SizedBox(width: 15,),
                                Text(widget.model.cash.toString(),style: TextStyle(fontSize: screenSize.width*.05),),
                              ],
                            ),
                          ],))
                      ],),
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: screenSize.height*0.08,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: KPrimaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: screenSize.width*0.25,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),),

                                child: TextButton(onPressed: (){}, child: Text('شحن',style: TextStyle(color: Colors.black,fontSize: screenSize.width*0.04),))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("ريال",style: TextStyle(fontSize: screenSize.width*.03,color: Colors.yellow),),
                                SizedBox(width: 15,),
                                Text(widget.model.cash.toString(),style: TextStyle(fontSize: screenSize.width*.05),),
                              ],
                            ),

                          ],),
                      ),

                    ),

                ],),
              ),
            ),
         );
        }
    );
  }
}
