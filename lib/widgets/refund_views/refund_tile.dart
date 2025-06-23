import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/l10n/generated/app_localizations.dart';
import '../../helpers/common_helper.dart';
import '../../helpers/empty_space_helper.dart';
import '../../utils/responsive.dart';
import '../../views/refund_details_view.dart';

class RefundTile extends StatelessWidget {
  final int id;
  final String status;
  final int numberOfProduct;

  const RefundTile({
    super.key,
    required this.id,
    required this.status,
    required this.numberOfProduct,
  });

  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (BuildContext context) => RefundDetailsView(refundId: id),
        ));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#$id',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: cc.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            EmptySpaceHelper.emptyHight(4),
            Text(
              '${AppLocalizations.of(context)!.status}: $status',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: cc.primaryColor,
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.number_of_products}: $numberOfProduct',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: cc.primaryColor,
              ),
            ),
            EmptySpaceHelper.emptyHight(4),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
