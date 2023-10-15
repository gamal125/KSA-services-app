import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services/layout/todo_layout.dart';
import 'package:services/login/login_screen.dart';
import 'package:services/register/cubit/cubit.dart';
import 'package:services/shared/local/bloc_observer.dart';
import 'package:services/shared/local/cache_helper.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'core/constance/constants.dart';
import 'cubit/AppCubit.dart';
import 'cubit/states.dart';
import 'login/cubit/maincubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Applocalizition.dart';


main() async {
  Widget widget;
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  await Firebase.initializeApp();
  var uId = CacheHelper.getData(key: 'uId');
  if (uId != null && uId != '') {
    widget = SplashScreenView(
      duration: 3000,
      pageRouteTransition: PageRouteTransition.SlideTransition,
      navigateRoute: Home_Layout(),
      text: ' Welcome dear',
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    );
  } else {
    widget = SplashScreenView(
      duration: 3000,
      pageRouteTransition: PageRouteTransition.SlideTransition,
      navigateRoute: LoginScreen(),
      text: 'Welcome',
      textType: TextType.ColorizeAnimationText,
      textStyle: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    );
  }
  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.startWidget});
  final Widget startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(
            create: (context) => AppCubit()..getService()..getUser(CacheHelper.getData(key: 'uId')??'')),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child:
     BlocConsumer<AppCubit, AppStates>(
    listener: (context,  state) {},
    builder: (context,  state) {
      return MaterialApp(
      localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
      Locale('en', 'US'), // English
      Locale('ar', 'SA'), // Arabic (Saudi Arabia)
      ],
      theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.white,
      appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black,statusBarIconBrightness: Brightness.light),
      backgroundColor: Colors.black,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black,unselectedIconTheme: IconThemeData(color: Colors.grey,),unselectedItemColor:  Colors.grey),
    fontFamily: 'jannah'),
    darkTheme: ThemeData(
      primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white,statusBarIconBrightness: Brightness.dark),
    backgroundColor: Colors.white,
    ),
    fontFamily: 'jannah'),
    debugShowCheckedModeBanner: false,
    themeMode: AppCubit.get(context).isDark? ThemeMode.light:ThemeMode.dark,
    home: startWidget,

    );
    },


     ));
  }
}


