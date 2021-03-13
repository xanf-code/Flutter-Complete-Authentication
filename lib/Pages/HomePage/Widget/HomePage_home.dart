import 'package:flutter/material.dart';
import 'package:my_app/Models/userDB.dart';
import 'package:my_app/Pages/Groups/displayGroups.dart';
import 'package:my_app/Pages/HomePage/Widget/welcome_widget.dart';
import 'package:my_app/Services/firebase_services/services.dart';
import 'package:my_app/Widget/HomePage/appBar.dart';
import 'package:my_app/Widget/auth.dart';
import 'package:my_app/Widget/const_gradient.dart';

import 'mainHeading.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream:
          FirebaseService(uid: Providers.of(context).auth.getCurrentUserUID())
              .userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              gradient: pageGradient,
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(gradient: pageGradient),
          child: ListView(
            children: [
              MainAppBar(
                image: snapshot.data.profileImage,
                userName: snapshot.data.name,
                uid: snapshot.data.uid,
                email: snapshot.data.email,
                status: snapshot.data.status,
              ),
              WelcomeText(
                userName: snapshot.data.name,
              ),
              SizedBox(
                height: 40,
              ),
              main_heading(
                type: "Public ",
                type2: "Circles 🌎",
              ),
              DisplayGroups(),
            ],
          ),
        );
      },
    );
  }
}
