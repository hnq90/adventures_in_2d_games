import 'package:adventures_in_2d_games/pub_nub_keys.dart';
import 'package:pubnub/pubnub.dart';

var pubnub = PubNub(
    defaultKeyset: Keyset(
        subscribeKey: subscribe,
        publishKey: publish,
        uuid: UUID('ReplaceWithYourClientIdentifier')));
