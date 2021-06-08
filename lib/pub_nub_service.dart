import 'package:adventures_in_2d_games/pub_nub_keys.dart' as pubnub_keys;
import 'package:pubnub/pubnub.dart';

class PubNubService {
  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: pubnub_keys.subscribe,
          publishKey: pubnub_keys.publish,
          uuid: UUID('ReplaceWithYourClientIdentifier')));
}
