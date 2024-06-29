import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/controller/payment_controller.dart';
import 'package:partners_dolinalpa/data/partners_datasource.dart';
import 'package:partners_dolinalpa/data/payments_datasource.dart';
import 'package:partners_dolinalpa/domain/repositories/i_partner_repository.dart';
import 'package:partners_dolinalpa/domain/repositories/i_payment_repository.dart';
import 'package:partners_dolinalpa/domain/use_case/partner_use_case.dart';
import 'package:partners_dolinalpa/domain/use_case/payment_use_case.dart';
import 'package:partners_dolinalpa/pages/calendar.dart';
import 'package:partners_dolinalpa/pages/history.dart';
import 'package:partners_dolinalpa/pages/user_history.dart';
import 'package:partners_dolinalpa/pages/home_screen.dart';
import 'package:partners_dolinalpa/pages/login.dart';
import 'package:partners_dolinalpa/pages/users.dart';
import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: './assets/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<IPaymentRepository>(FirestorePaymentsRepository());
  Get.put<IPartnerRepository>(FirestorePartnersRepository());
  Get.put(PaymentUseCase(Get.find<IPaymentRepository>()));
  Get.put(PartnerUseCase(Get.find<IPartnerRepository>()));
  Get.put(PaymentController());
  Get.put(PartnerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socios Dolinalpa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.black,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
        useMaterial3: true,
        colorScheme: const ColorScheme.dark()
            .copyWith(primary: Colors.blue, secondary: Colors.blue),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/payments') {
          final idSocio = settings.arguments as String;
          return MaterialPageRoute(
              builder: (context) => PaymentsScreen(idSocio: idSocio));
        }
        return null;
      },
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/partners': (context) => const UserScreen(),
        '/history': (context) => const HistoryScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}
