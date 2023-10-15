import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/core/constance/constants.dart';

import '../../Applocalizition.dart';
import '../../model/UserModel.dart';

class Profiledetails extends StatelessWidget {
   const Profiledetails({required  this.model,super.key});
 final UserModel model;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_sharp,color: KPrimaryColor,),onPressed: (){
          Navigator.pop(context);
        },),
        title:  Center(child: Text(AppLocalizations.of(context)!.translate('profile'),style: const TextStyle(color: KPrimaryColor),),),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      KPrimaryColor,
                      Colors.white, // Second color (bottom half)
                    ],
                    stops: [
                      0.25,
                      0.25
                    ], // Set the stops to create a sharp transition between the colors
                  ),
                ),
                child: Column(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 72.0),
                      child: Stack(

                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            model.image ==
                                '' ||
                                model.image ==
                                    null
                                ? const CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                    'assets/images/user.png'),
                                radius: 80,
                              ),
                            )
                                : CircleAvatar(
                              backgroundImage: NetworkImage(
                                  model.image!),
                              radius: 80,
                            ),

                          ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.name!,
                                    style: const TextStyle(
                                      color: KPrimaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(AppLocalizations.of(context)!.translate('username')),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                                  model.male? Text(AppLocalizations.of(context)!.translate('male'),style: const TextStyle(color: KPrimaryColor),):
                                   Text(AppLocalizations.of(context)!.translate('female'),style: const TextStyle(color: KPrimaryColor),),
                              Text(AppLocalizations.of(context)!.translate('gen')),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              model.user?Text(AppLocalizations.of(context)!.translate('User'),style: const TextStyle(color: KPrimaryColor),):
                              Text(AppLocalizations.of(context)!.translate('empl'),style: const TextStyle(color: KPrimaryColor),),
                              Text(AppLocalizations.of(context)!.translate('usertype')),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              model.state?Text(AppLocalizations.of(context)!.translate('online'),style: const TextStyle(color: KPrimaryColor),):
                              Text(AppLocalizations.of(context)!.translate('offline'),style: const TextStyle(color: KPrimaryColor),),
                              Text(AppLocalizations.of(context)!.translate('state')),

                            ],
                          ),
                          Text(AppLocalizations.of(context)!.translate('email')),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.email!,
                                    style: const TextStyle(
                                        color: KPrimaryColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          model.phone!=''?  Text(AppLocalizations.of(context)!.translate('phone')):const Text(''),
                          model.phone!=''? Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 14),
                            child: Text(
                              model.phone!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18),
                            ),
                          ):const Text(''),
                        ],
                      ),
                    ),




                  ],
                ),
              ),
            )
            ,],
        ),
      ),
    );
  }
}
