import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/core/constance/constants.dart';
import '../Applocalizition.dart';
import '../components/components.dart';
import '../cubit/AppCubit.dart';
import '../layout/todo_layout.dart';
import '../login/login_screen.dart';
import '../shared/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';


class RegisterScreen extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final taxController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  late final String name ;
  late final String email ;
  late final String imageUrl ;
  late final File? profileImage;
  final pickerController = ImagePicker();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<RegisterCubit, RegisterState>(
       listener: (context, state) {
        if (state is RegisterSuccessState) {

          navigateAndFinish(context, LoginScreen());
        }
        if (state is SuccessState) {
          CacheHelper.saveData(key: 'uId', value: state.uId);
           AppCubit.get(context).ud=state.uId;
          AppCubit.get(context).getUser(state.uId);

          AppCubit.get(context).currentIndex=0;
           navigateAndFinish(context, Home_Layout());
        }

      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.translate('create'),style: const TextStyle(color:KPrimaryColor,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'Dubai',),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5,bottom:10),
                      child: Column(children: [

                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty||!value.endsWith('.com')) {

                              return AppLocalizations.of(context)!.translate('email2');
                            }
                            return null;
                          },
                          label: AppLocalizations.of(context)!.translate('email'),
                          hint: AppLocalizations.of(context)!.translate('email'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.translate('username');
                            }
                            return null;
                          },
                          label: AppLocalizations.of(context)!.translate('username'),
                          hint: AppLocalizations.of(context)!.translate('username'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.translate('phone2');
                            }
                            return null;
                          },
                          label: AppLocalizations.of(context)!.translate('phone'),
                          hint: AppLocalizations.of(context)!.translate('phone'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.translate('pass');
                            }
                            return null;
                          },
                          label: AppLocalizations.of(context)!.translate('pass'),
                          hint: AppLocalizations.of(context)!.translate('pass'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: passwordController2,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)!.translate('pass2');
                            }
                            return null;
                          },
                          label: AppLocalizations.of(context)!.translate('pass2'),
                          hint:AppLocalizations.of(context)!.translate('pass2'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! CreateUserInitialState,
                          builder: (context) => Center(
                            child: defaultMaterialButton(
                               function: () {
                                if (formKey.currentState!.validate()) {
                                  if(passwordController.text!=passwordController2.text){
                                    showToast(text:AppLocalizations.of(context)!.translate('pass3') , state: ToastStates.error);
                                  }else{
                                    if(phoneController.text.length<10){
                                      showToast(text:AppLocalizations.of(context)!.translate('phone2') , state: ToastStates.error);
                                    }else{
                                      RegisterCubit.get(context).userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                      );}}}},
                              text: AppLocalizations.of(context)!.translate('Register'),
                              radius: 20, color: KPrimaryColor,
                            ),
                          ),
                          fallback: (context) =>
                              Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                    color: KPrimaryColor.withOpacity(.8),
                                    size: screenSize.width / 12,)) ,),
                        Row(
                          children: [
                            Text(AppLocalizations.of(context)!.translate('have account'),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey),),
                            TextButton(onPressed: () { navigateTo(context, LoginScreen()); },
                              child:Text(AppLocalizations.of(context)!.translate('login'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: HexColor('#F88B94'),),),
                            ),
                          ],
                        ),

                      ]),
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
