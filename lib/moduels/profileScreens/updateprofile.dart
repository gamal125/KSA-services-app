import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Applocalizition.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import '../../layout/todo_layout.dart';



class UpdateProfileScreen extends StatelessWidget {


  final  formKey = GlobalKey<FormState>();
  final imageController = TextEditingController();
  final nameController = TextEditingController();
  var phoneController = TextEditingController();

  UpdateProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    var c= AppCubit.get(context);
    imageController.text=c.userdata!.image!;
    nameController.text=c.userdata!.name!;
    c.userdata!.phone!=''?phoneController.text=c.userdata!.phone!:null;


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ImageSuccessStates) {
          AppCubit.get(context).getUser(c.ud);
          AppCubit.get(context).changeIndex(2);
          navigateAndFinish(context, Home_Layout());

        }
        if (state is UpdateProductSuccessStates) {
          AppCubit.get(context).getUser(c.ud);
          AppCubit.get(context).changeIndex(2);
          navigateAndFinish(context, Home_Layout());

        }

      },
      builder: (context, state) {
        var imageo=c.userdata!.image!;
        return Scaffold(


          appBar: AppBar( ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            c.getImage2();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 300,

                            decoration: c.PickedFile2!=null?
                            BoxDecoration(image: DecorationImage(image: FileImage(c.PickedFile2!)))
                                : BoxDecoration(image:
                            imageo==''?
                            const DecorationImage(image: NetworkImage(
                                'https://www.leedsandyorkpft.nhs.uk/advice-support/wp-content/uploads/sites/3/2021/06/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg')):
                            DecorationImage(image: NetworkImage(imageo) )

                            )
                            ,
                          ),
                        ) ,

                        Center(

                          child: Column(
                            children: [

                              Container(
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white24
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20,bottom:10),
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      prefix: Icons.drive_file_rename_outline_sharp,
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
                                      height: 20,
                                    ),

                                    ////////////////////
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      prefix: Icons.phone,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return AppLocalizations.of(context)!.translate('phone');
                                        }
                                        return null;
                                      },
                                      label: AppLocalizations.of(context)!.translate('phone'),
                                      hint: AppLocalizations.of(context)!.translate('phone'), tcolor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                                    ),


                                    const SizedBox(
                                      height: 20,
                                    ),

                                    ConditionalBuilder(
                                      condition:state is! ImageintStates ,
                                      builder: ( context)=> Center(
                                        child: defaultMaterialButton(function: () {
                                          if (formKey.currentState!.validate()) {
                                            if(AppCubit.get(context).PickedFile2!=null){
                                              AppCubit.get(context).uploadProfileImage(
                                                name: nameController.text,
                                                phone: phoneController.text,
                                                email: AppCubit.get(context).userdata!.email!,
                                              );}
                                            else{
                                              AppCubit.get(context).updateProfile(
                                                name: nameController.text,
                                                phone: phoneController.text,
                                                email: AppCubit.get(context).userdata!.email!, image: c.userdata!.image!, user: c.userdata!.user,

                                              );
                                            }

                                          }

                                        }, text: AppLocalizations.of(context)!.translate('save'), radius: 20, color: KPrimaryColor,),
                                      ),
                                      fallback: (context)=>
                                          Center(
                                              child: LoadingAnimationWidget.inkDrop(
                                                color: KPrimaryColor.withOpacity(.8),
                                                size: screenSize.width / 12,
                                              )) ,
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                  ]),
                                ),


                              ),


                            ],
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
