import 'package:pubnub/pubnub.dart';

class PubNubService {
  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: 'sub-c-a12a287e-c468-11eb-9e40-ea6857a81ff7',
          publishKey: 'pub-c-5d34f973-30dc-4083-9714-52b067f7efd8',
          uuid: UUID('ReplaceWithYourClientIdentifier')));
}
