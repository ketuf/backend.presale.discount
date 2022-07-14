import 'package:baschack/models/card.dart';
import 'package:baschack/models/card_user.dart';
import 'package:baschack/models/config.dart';
import 'package:baschack/models/payment_user.dart';
import 'package:baschack/models/user.dart';
import 'package:conduit/conduit.dart';
import 'package:dio/dio.dart' as d;

import '../models/payment.dart';
class BalanceController extends ResourceController {
    final ManagedContext context;
    final Config config;
    BalanceController(this.context, this.config);
    @Operation.get()
    Future<Response> balance() async {
      final userQuery = Query<User>(context)..where((i) => i.id).equalTo(request!.authorization!.ownerID);
      final user = await userQuery.fetchOne();
      final bal = await d.Dio().get('${config.gladiatorsurl}/statera/false/${user!.public}');
      return Response.ok({ "balance": bal.data['statera'] });
    }
    //how many relations can we vind between the user and the card
    @Operation.get('lsd')
    Future<Response> cardBalance() async {
      final cardUserQuery = Query<CardUser>(context)
      ..where((x) => x.user!.id == request!.authorization!.ownerID)
      ..join(object: (x) => x.card);
      final cardUsers = await cardUserQuery.fetch();
      return Response.ok(cardUsers);
    }
}