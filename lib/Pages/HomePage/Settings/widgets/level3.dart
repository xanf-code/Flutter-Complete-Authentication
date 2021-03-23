import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/Services/Authentication_service/auth_service.dart';
import 'package:my_app/State/generate_dynamic_link.dart';
import 'package:my_app/Widget/bottom_card.dart';

class Level3 extends StatelessWidget {
  final AuthService authService;
  final GenerateLink dynamicLinkService;

  const Level3({Key key, this.authService, this.dynamicLinkService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authService.getCurrentUserUID())
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        final userDocument = snapshot.data;
        if (!snapshot.hasData) {
          return const Center(
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          );
        }
        return userDocument["ref_link"] != " "
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 25,
                  right: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FeatherIcons.share2,
                          color: Colors.blue,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "ShareFolio Link",
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xFF21212b),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userDocument['ref_link'].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.share,
                              color: Colors.white70,
                              size: 15,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _modalBottomSheetMenu(context, userDocument);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 25,
                  right: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ShareFolio Link",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFBB86FC),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          dynamicLinkService.generateLink(
                            authService.getCurrentUserUID(),
                            context,
                            "${userDocument['name']} | ShareFolio",
                            "${userDocument['name']}(@${userDocument['name']}) | ShareFolio- Personal Profile Link",
                            userDocument['profileImage'].toString() == " "
                                ? "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png"
                                : userDocument['profileImage'].toString(),
                          );
                        },
                        child: const Text("Show Link"),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  void _modalBottomSheetMenu(
      BuildContext context, DocumentSnapshot userDocument) {
    showModalBottomSheet(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (builder) {
        return CardBottom(
          userDocument: userDocument,
        );
      },
    );
  }
}
