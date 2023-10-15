import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:services/components/components.dart';
import 'package:services/core/constance/constants.dart';
import 'package:services/cubit/AppCubit.dart';
import 'package:services/model/UserModel.dart';
import '../../Applocalizition.dart';
import '../../cubit/states.dart';
import '../../model/message_model.dart';
import '../payment/pages/auth_screen.dart';

class AdminComplaintMessageScreen extends StatefulWidget {
  static const String routeName = 'MessageScreen';

  const AdminComplaintMessageScreen({super.key,  required this.R_userdata,required this.name});

  final UserModel R_userdata;
  final String name;
  @override
  State<AdminComplaintMessageScreen> createState() => _AdminComplaintMessageScreenState();
}

class _AdminComplaintMessageScreenState extends State<AdminComplaintMessageScreen> {
  bool payment = false;
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built
  }

  @override
  Widget build(BuildContext context) {
    var c = AppCubit.get(context);
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
          if( state is GetComplaintMessageSuccessState){
            if(c.ComplaintMessage.isNotEmpty){
            WidgetsBinding.instance
                .addPostFrameCallback((_) => scrollToBottom());}
          }

            if (state is SendMessageSuccessState) {}
            if (state is DeleteMessageSuccessState) {}
          },
          builder: (context, state) {
            c.ComplaintMessage.isNotEmpty
                ? c.ComplaintMessage.last.text == '###payment###'
                ? payment = true
                : false
                : null;
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                              datetime: DateTime.now().toString(), price: '')
                              : showToast(
                              text:AppLocalizations.of(context)!.translate('already sent'),
                              state: ToastStates.error);
                        },
                        icon: const Icon(
                          Icons.monetization_on_outlined,
                          color: KPrimaryColor,
                        ),
                      )
                          : Text(''),
                      Text(
                        widget.name,
                        style: TextStyle(color:AppCubit.get(context).isDark?Colors.white:Colors.black),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: widget.R_userdata.image != ''
                                  ? NetworkImage('${widget.R_userdata.image!}')
                                  : const NetworkImage(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                              )),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                  elevation: 0,

                ),
                body: ConditionalBuilder(
                  condition: c.ComplaintMessage.isNotEmpty,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message = c.ComplaintMessage[index];
                                if (c.userdata!.uId == message.S_uId) {
                                  return buildMymessage(message);
                                } else {
                                  return buildmessage(message);
                                }
                              },
                              separatorBuilder: (context, index) =>
                              const SizedBox(
                                height: 15,
                              ),
                              itemCount: c.ComplaintMessage.length),
                        ),
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
                                  decoration: BoxDecoration(
                                      color: KPrimaryColor,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                                  height: 40,
                                  width: 45,
                                  child: MaterialButton(
                                    minWidth: 1,
                                    color: KPrimaryColor,
                                    onPressed: () {
                                      c.sendcomplaintmessage(
                                          text: textController.text,
                                          R_uId: widget.R_userdata.uId!,
                                          datetime: DateTime.now().toString(), price: '');
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
                                      style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                      controller: textController,
                                      decoration:  InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                          hintText:  AppLocalizations.of(context)!.translate('type'),),
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
                      Expanded(child: Text(AppLocalizations.of(context)!.translate('No itemsm'),style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),)),
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
                                    c.sendcomplaintmessage(
                                        text: textController.text,
                                        R_uId: widget.R_userdata.uId!,
                                        datetime: DateTime.now().toString(), price: '');
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
                                    style: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                    controller: textController,
                                    decoration:  InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(color: AppCubit.get(context).isDark?Colors.white:Colors.black,),
                                        hintText: AppLocalizations.of(context)!.translate('type'),),
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

  Widget buildmessage(messageModel model) => model.text == '###payment###'
      ? Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {

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
                navigateTo(context, AuthScreen( model: widget.R_userdata, price: '',));
              } else if (state is PaymentAuthErrorStates) {
                isLoading = false;
              }
            },
            builder: (context, state) {

              return Center(
                child: MaterialButton(
                  onPressed: () {

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
          borderRadius: const BorderRadiusDirectional.only(
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
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
          )),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: Text(
          AppLocalizations.of(context)!.translate('payment'),
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
  );
  void scrollToBottom() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
}
