import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tution_wala/widgets/pending_contracts_page.dart';
import 'package:tution_wala/widgets/tutor_pending_contract_list.dart';

class TutorPendingContractsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Material(
              color: Color.fromARGB(255, 245, 245, 245),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                    16), // adjust the radius value to your liking
                bottom: Radius.circular(
                    16), // adjust the radius value to your liking
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 20, top: 20),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.doc_plaintext,
                          size: 34,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Contract Requests",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              // color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TutorPendingContractsList(),
                  ))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Expanded(
          child: Center(),
        ),
      ],
    );
  }
}
