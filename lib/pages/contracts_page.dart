import 'package:flutter/material.dart';
import 'package:tution_wala/widgets/ongoing_contract_list.dart';
import 'package:tution_wala/widgets/pending_contracts_page.dart';

class ContractsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(
                      "Pending contracts",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        // color: Colors.white
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(
                                16), // adjust the radius value to your liking
                            bottom: Radius.circular(
                                16), // adjust the radius value to your liking
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: PendingContractsList(),
                          )))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(
                      "Ongoing contracts",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        // color: Colors.white
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(
                                16), // adjust the radius value to your liking
                            bottom: Radius.circular(
                                16), // adjust the radius value to your liking
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: OngoingContractsList()))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
