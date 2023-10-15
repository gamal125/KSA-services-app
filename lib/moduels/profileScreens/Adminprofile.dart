import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/profileScreens/profile.dart';
import 'package:services/moduels/profileScreens/profiledetails.dart';
import '../../Applocalizition.dart';
import '../../components/components.dart';
import '../../core/constance/constants.dart';
import '../../cubit/AppCubit.dart';
import '../../cubit/states.dart';
import 'AdminComplaintChatsScreen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  var isChecked = false;
  List<bool> _switchValues = [];
  List<bool> _switchValues2 = [];
  List<bool> _switchValues3 = [];
  List<UserModel> list = [];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var cubit = AppCubit.get(context);
    cubit.getAllusers();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is GetComplaintUsersLoadingState){
          navigateTo(context, const AdminComplaintChatsScreen());
        }
        if (state is GetAllUsersSuccessState) {
          list = [];
          list = AppCubit.get(context).users;
          list.forEach((element) {
            _switchValues3.add(element.state);
            _switchValues2.add(element.male);
            _switchValues.add(element.user);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(

            actions: [
              Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(onPressed: (){AppCubit.get(context).changemode();}, icon: Icon(Icons.brightness_medium,color: AppCubit.get(context).isDark?Colors.white:Colors.black,)),

                TextButton(onPressed: (){
                  cubit.getComplaintUsersid();
                },child:  Row(
                  children: [

                    Text(AppLocalizations.of(context)!.translate('Complaints'),style: const TextStyle(color: Colors.red),),
                    const Icon(Icons.list_alt_outlined,color: Colors.red,),
                  ],
                ),),
                Text(
                  AppLocalizations.of(context)!.translate('AllUsers'),
                style:
                const TextStyle(color: KPrimaryColor, fontWeight: FontWeight.bold),
              ),
                IconButton(onPressed: (){navigateTo(context, const ProfileScreen());}, icon:const Icon( Icons.person,color:KPrimaryColor ,))],)),
              const SizedBox(width: 5,),
            ],

          ),
          body: ConditionalBuilder(
            builder: (context) => list.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsetsDirectional.only(start: 10.0, top: 10),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) =>
                        UsersList(list[index], index, context),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10.0,
                    ),
                    itemCount: AppCubit.get(context).users.length,
                  )
                : const Center(child: Text('no users yet')),
            condition: state is! GetAllUsersLoadingState &&
                state is! AppChangeBottomNavBarState,
            fallback: (context) =>Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: KPrimaryColor.withOpacity(.8),
                  size: screenSize.width / 12,
                )) ,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: KPrimaryColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              selectedIconTheme: const IconThemeData(
                color: KPrimaryColor,
              ),
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

  Widget UsersList(UserModel model, int i, context) => InkWell(
    onTap: (){
      navigateTo(context, Profiledetails(model: model,));
    },
    child: Card(
          color: Colors.green.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.none,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    model.image != ''
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(model.image!),
                            radius: 40,
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage('assets/icon/1.jpg'),
                            radius: 40,
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(child: Text(model.name!,maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        _switchValues[i]
                            ? Text(
                          AppLocalizations.of(context)!.translate('User'),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: KPrimaryColor,
                                ),
                              )
                            : Text(
                          AppLocalizations.of(context)!.translate('empl'),
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                        Switch(
                          value: _switchValues[i],
                          onChanged: (value) {
                            setState(() {
                              _switchValues[i] = value;

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(model.uId)
                                  .update({'user': _switchValues[i]});
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _switchValues2[i]
                            ?  Text(
                          AppLocalizations.of(context)!.translate('male'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: KPrimaryColor,
                                ),
                              )
                            :  Text(
                          AppLocalizations.of(context)!.translate('female'),
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                        Switch(
                          value: _switchValues2[i],
                          onChanged: (value) {
                            setState(() {
                              _switchValues2[i] = value;
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(model.uId)
                                  .update({'male': _switchValues2[i]});
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _switchValues3[i]
                        ?  Text(
                      AppLocalizations.of(context)!.translate('online'),
                      style: const TextStyle(
                        fontSize: 20,
                        color: KPrimaryColor,
                      ),
                    )
                        :  Text(
                      AppLocalizations.of(context)!.translate('offline'),
                      style:
                      const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    Switch(
                      value: _switchValues3[i],
                      onChanged: (value) {
                        setState(() {
                          _switchValues3[i] = value;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(model.uId)
                              .update({'state': _switchValues3[i]});
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
  );
}
