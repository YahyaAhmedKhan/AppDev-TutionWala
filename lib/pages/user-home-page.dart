// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tution_wala/service/auth_service.dart';

// class UserHomePage extends StatelessWidget {
//   const UserHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ,
//     );
//   }
// }


// class homePageContent extends ConsumerWidget {
//   const homePageContent({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Future<String> getRole() async {
//       final authService = ref.read(authServiceProvider);

//     if (ref.read(authServiceProvider).getCurrentUser() != null){
//       String email = authService.getCurrentUser()!.email!;

//     }

//     return "";

    
    
//     }



//     return Center(
//       child: Builder(builder: (context){
//         AsyncValue<String> data = getRole();

//       } ),
      
//     );
//   }
// }
