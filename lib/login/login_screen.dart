
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Applocalizition.dart';
import '../components/components.dart';
import '../core/constance/constants.dart';
import '../cubit/AppCubit.dart';
import '../layout/todo_layout.dart';
import '../register/register_screen.dart';
import '../shared/local/cache_helper.dart';
import 'cubit/maincubit.dart';
import 'cubit/state.dart';
class LoginScreen extends StatelessWidget {
 final  formKey = GlobalKey<FormState>();

 final emailController = TextEditingController();

 final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
         if (state is LoginSuccessState) {

            CacheHelper.saveData(key: 'uId', value: state.uId);

            String? uid=CacheHelper.getData(key: 'uId');
            AppCubit.get(context).getUser(state.uId);
            AppCubit.get(context).ud=state.uId;
            FirebaseFirestore.instance.collection('users').doc(uid).update({'state':false});
            AppCubit.get(context).getUser(state.uId);

            AppCubit.get(context).currentIndex=0;
                navigateAndFinish(context,  Home_Layout());



      }},
      builder: (context, state) {
        return Scaffold(

          appBar: AppBar(),
          body: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
              },

              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            AppLocalizations.of(context)!.translate('login'),
                            style: const TextStyle(
                              color: KPrimaryColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate('email2');
                              }
                              return null;
                            },
                            label: AppLocalizations.of(context)!.translate('email'),
                            hint: AppLocalizations.of(context)!.translate('email'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              // LoginCubit.get(context).emit(LoginInitialState());
                            },
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.key,
                            suffix: LoginCubit.get(context).suffix,
                            isPassword: LoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              LoginCubit.get(context).ChangePassword();
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!.translate('pass2');
                              }
                              return null;
                            },
                            label: AppLocalizations.of(context)!.translate('pass'),
                            hint: AppLocalizations.of(context)!.translate('pass'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => Center(
                              child: defaultMaterialButton(

                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: AppLocalizations.of(context)!.translate('login'),
                                radius: 20,
                              ),
                            ),
                            fallback: (context) =>
                                Center(
                                    child: LoadingAnimationWidget.inkDrop(
                                      color: KPrimaryColor,
                                      size: screenSize.width / 12,
                                    )) ,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                               Text(
                                 AppLocalizations.of(context)!.translate('no-have account'),
                                style:
                                    TextStyle(fontSize: MediaQuery.of(context).size.width * 0.026, color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),

                              defaultTextButton(

                                function: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                text: AppLocalizations.of(context)!.translate('create'),
                              ),
                            ],
                          ),

                          Center(
                            child: IconButton(onPressed: () {
                              LoginCubit.get(context).signInWithGoogle();
                            },
                              icon:SvgPicture.asset('assets/icon/google.svg',height: 48,width: 48,),
                            ),
                          ),
                        ],
                      ),
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
