import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

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

          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      child:  Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('إنشاء حساب',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'Dubai',),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,left: 5,bottom:10),
                        child: Column(children: [

                          defaultTextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'البريد الالكتروني';
                              }
                              return null;
                            },
                            label: 'البريد الالكتروني',
                            hint: 'البريد الالكتروني',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,

                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'الاسم الكامل';
                              }
                              return null;
                            },
                            label: 'الاسم الكامل',
                            hint: 'الاسم الكامل',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'رقم الهاتف';
                              }
                              return null;
                            },
                            label: 'رقم الهاتف',
                            hint: 'رقم الهاتف',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,

                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'كلمة المرور';
                              }
                              return null;
                            },
                            label: 'كلمة المرور',
                            hint: 'كلمة المرور',
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextFormField(
                            controller: passwordController2,
                            keyboardType: TextInputType.text,

                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'تاكيد كلمة المرور';
                              }
                              return null;
                            },
                            label: 'تاكيد كلمة المرور',
                            hint: 'تاكيد كلمة المرور',
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
                                      showToast(text:'كلمة المرور غير متطابقه' , state: ToastStates.error);
                                    }else{
                                      if(phoneController.text.length<10){
                                        showToast(text:'رقم الهاتف غير صحيح' , state: ToastStates.error);
                                      }else{
                                        RegisterCubit.get(context).userRegister(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text,
                                          phone: phoneController.text,
                                        );
                                      }

                                    }

                                  }
                                 },
                                text: 'تسجيل دخول',
                                radius: 20, color: HexColor('#464646'),
                              ),
                            ),
                            fallback: (context) =>
                                const Center(child: CircularProgressIndicator()),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              TextButton(onPressed: () { navigateTo(context, LoginScreen()); },
                                child:Text(' تسجيل دخول',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: HexColor('#F88B94'),),),
                              ),
                              const Text('هل تمتلك حساب مسبقا؟',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey),),
                            ],
                          ),

                          IconButton(onPressed: () {
                            RegisterCubit.get(context).signInWithGoogle();
                          },
                            icon:SvgPicture.asset('assets/icon/google.svg',height: 48,width: 48,),
                          ),
                        ]),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
