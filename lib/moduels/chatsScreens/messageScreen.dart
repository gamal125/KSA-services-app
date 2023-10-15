import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:services/components/components.dart';
import 'package:services/core/constance/constants.dart';

import 'package:services/cubit/AppCubit.dart';
import 'package:services/layout/todo_layout.dart';
import 'package:services/model/UserModel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Applocalizition.dart';
import '../../cubit/states.dart';
import '../../model/message_model.dart';
import '../payment/pages/auth_screen.dart';
import 'complaintMessageScreen.dart';

class MessageScreen extends StatefulWidget {
  static const String routeName = 'MessageScreen';

  MessageScreen({super.key,  required this.R_userdata,});

  final UserModel R_userdata;


  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool payment = false;
  final formKey = GlobalKey<FormState>();
   String price='';
  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    // Scroll to the bottom when the widget is built
  }

  @override
  Widget build(BuildContext context)  {
    var c = AppCubit.get(context);
    if(c.messages.isEmpty) {
      AppCubit.get(context).sendstartmessag(text: ' مرحبا!', R_uId: widget.R_userdata.uId!, datetime: DateTime.now().toString(), price: '');
    }


    c.getprice(R_uId: widget.R_userdata.uId!);
    return Builder(
      builder: (BuildContext context)  {

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state)  {
            if (state is GetPriceMessageSuccessState){
              price=state.price;

            }
            if (state is GetMessageSuccessState) {
              if (c.messages.isNotEmpty) {
                c.messages.last.text == '###payment###'
                    ? payment = true
                    : payment = false;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => scrollToBottom());
              } else {
                c.currentIndex=0;
                navigateAndFinish(context, Home_Layout());
              }

              if (!c.userdata!.user) {
                if (c.messages.isEmpty) {
                  showToast(text: AppLocalizations.of(context)!.translate('request canceled'), state: ToastStates.error);

                  FirebaseFirestore.instance.collection('users').doc(c.ud).collection('chats').doc(widget.R_userdata.uId).delete();
                  FirebaseFirestore.instance.collection('users').doc(widget.R_userdata.uId).collection('chats').doc(c.ud).delete();

                  c.currentIndex=0;
                  navigateAndFinish(context, Home_Layout());
                }
              }else{
                if (c.messages.isEmpty) {


                  FirebaseFirestore.instance.collection('users').doc(c.ud).collection('chats').doc(widget.R_userdata.uId).delete();
                  FirebaseFirestore.instance.collection('users').doc(widget.R_userdata.uId).collection('chats').doc(c.ud).delete();

                  c.currentIndex=0;
                  navigateAndFinish(context, Home_Layout());
                }
              }

            }

          },
          builder: (context, state) {
            c.messages.isNotEmpty
                ? c.messages.last.text == '###payment###'
                    ? payment = true
                    : false
                : null;
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      c.currentIndex=0;
                      navigateAndFinish(context, Home_Layout());
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: KPrimaryColor,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      !c.userdata!.user
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  payment = !payment;
                                });
                                payment
                                    ? c.sendmessage(
                                        text: '###payment###',
                                        R_uId: widget.R_userdata.uId!,
                                        datetime: DateTime.now().toString(), price: price)
                                    : showToast(
                                        text: AppLocalizations.of(context)!.translate('already sent'),
                                        state: ToastStates.error);
                              },
                              icon: const Icon(
                                Icons.monetization_on_outlined,
                                color: KPrimaryColor,
                              ),
                            )
                          : Text(''),

                      c.userdata!.user? IconButton(onPressed: () {
                        sendToWhatsApp(phone: widget.R_userdata.phone.toString());
                      },
                        icon: SvgPicture.asset(
                          'assets/icon/whatsapp96.svg',),
                      ):SizedBox(width: 1,height: 1,),
                      !c.userdata!.user
                          ? TextButton(
                        onPressed: () {
                          AppCubit.get(context).deleteAll(
                            id: widget.R_userdata.uId!,
                            allmessages: AppCubit.get(context).messages,
                          );
                           AppCubit.get(context).currentIndex=0;
                          AppCubit.get(context).changeIndex(0);
                          navigateAndFinish(context, Home_Layout());
                        },
                        child: Text(AppLocalizations.of(context)!.translate('exit'),style: TextStyle(fontSize: 10,color: AppCubit.get(context).isDark?Colors.white:Colors.black,),)
                      )
                          : TextButton(
                          onPressed: () {

navigateTo(context, ComplaintMessageScreen(R_id: '8DxVS7sTApPRE3oD1SZvLEjHXNg1',));
                          },
                          child: Text(AppLocalizations.of(context)!.translate('Complaints'),style: TextStyle(fontSize: 11,color: Colors.red),)
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Text(

                          widget.R_userdata.name!,
                          style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,fontSize: 14),maxLines: 1,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: widget.R_userdata.image != ''
                                      ? NetworkImage('${widget.R_userdata.image!}')
                                      : const NetworkImage(
                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                                        )),
                            )),
                        Padding(
                          padding:  const EdgeInsetsDirectional.only(bottom: 3.0,end: 3),
                          child: CircleAvatar(radius: 5,backgroundColor: widget.R_userdata.state? Colors.green:Colors.grey,),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                  elevation: 0,

                ),
                body: ConditionalBuilder(
                  condition: c.messages.isNotEmpty,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message = c.messages[index];
                                if (c.userdata!.uId == message.S_uId) {
                                  return buildMymessage(message);
                                } else {
                                  return buildmessage(message,price);
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 15,
                                  ),
                              itemCount: c.messages.length),
                        ),
                        payment
                            ? Text(AppLocalizations.of(context)!.translate('chat disabled'),style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),)
                            : Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppCubit.get(context).isDark?Colors.white:Colors.black, width: 1),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        decoration: const BoxDecoration(

                                            borderRadius: BorderRadius.all(

                                                Radius.circular(20))),
                                        height: 40,
                                        width: 45,
                                        child: MaterialButton(
                                          minWidth: 1,
                                          color:KPrimaryColor,
                                          onPressed: () {
                                            c.sendmessage(
                                                text: textController.text,
                                                R_uId: widget.R_userdata.uId!,
                                                datetime:
                                                    DateTime.now().toString(), price: price);
                                            textController.text = '';
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icon/Icon material-send.svg',
                                            fit: BoxFit.contain,
                                            height: 18,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0, left: 5),
                                      child: TextFormField(
                                        style:TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,) ,
                                        textAlign: TextAlign.end,
                                        controller: textController,
                                        decoration:  InputDecoration(
                                            border: InputBorder.none,

                                            hintStyle: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                            hintText: AppLocalizations.of(context)!.translate('type')),
                                      ),
                                    )),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  fallback: (context) => Column(
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context)!.translate('No itemsm'))),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: KPrimaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                height: 40,
                                width: 45,
                                child: MaterialButton(
                                  minWidth: 1,
                                  color: KPrimaryColor,
                                  onPressed: () {
                                    c.sendmessage(
                                        text: textController.text,
                                        R_uId: widget.R_userdata.uId!,
                                        datetime: DateTime.now().toString(), price: price);
                                    textController.text = '';
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icon/Icon material-send.svg',
                                    fit: BoxFit.contain,
                                    height: 18,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, left: 5),
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: textController,
                                decoration:  InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context)!.translate('type')),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  bool isLoading = false;

  Widget buildmessage(messageModel model,String price) => model.text == '###payment###'
      ? Align(
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  AppCubit.get(context).deleteAll(
                    id: widget.R_userdata.uId!,
                    allmessages: AppCubit.get(context).messages,
                  );
                  AppCubit.get(context).getUsersIdChats();
                  AppCubit.get(context).changeIndex(0);
                  navigateAndFinish(context, Home_Layout());
                },
                color: Colors.red,
                child:  Text(AppLocalizations.of(context)!.translate('no pay')),
              ),
              const SizedBox(
                width: 10,
              ),
              BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {
                  if (state is PaymentAuthLoadingStates) {
                    isLoading = true;
                  } else if (state is PaymentAuthSuccessStates) {
                    isLoading = false;
                 navigateTo(context, AuthScreen( model: widget.R_userdata, price: price,));
                  } else if (state is PaymentAuthErrorStates) {
                    isLoading = false;
                  }
                },
                builder: (context, state) {
                  var cubit = AppCubit.get(context);

                  return Center(
                    child: MaterialButton(
                      onPressed: () {
                        cubit.getAuthToken();

                      },
                      color: Colors.green,
                      child:  Text(AppLocalizations.of(context)!.translate('pay')),
                    ),
                  );
                },
              ),
            ],
          ))
      : Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text('${model.text}',style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),),
            ),
          ),
        );
  Widget buildMymessage(messageModel model) => model.text != '###payment###'
      ? Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text('${model.text}',style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),),
            ),
          ),
        )
      : Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(
                AppLocalizations.of(context)!.translate('payment'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
  void scrollToBottom() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
  void sendToWhatsApp({required String phone,})async{
    var mes='مرحبا!';
    var url='https://api.whatsapp.com/send?phone=2$phone&text=$mes';
    await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
  }
}
