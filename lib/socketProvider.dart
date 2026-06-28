
import 'dart:async';
import 'dart:convert';

import 'package:gymatvendor/data/models/roomModel.dart';
import 'package:gymatvendor/presentations/chat_module/provider/chat_provider.dart';
import 'package:gymatvendor/presentations/profile_module/provider/profile_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/models/messageModel.dart';
import '../injection.dart';
import 'core/app_url/app_url.dart';
import 'data/models/user_model.dart';

class SocketProvider {
IO.Socket? socket;
Set<num> ids = {};

bool _baseListenersRegistered = false;
bool _socketDebugRegistered = false;

/// Node socket events:
/// AppUrls.acquire = 'acquire'
/// AppUrls.startRecording = 'start'
/// AppUrls.stopRecording = 'end'
static const String _acquireRecordingEvent = AppUrls.acquire;
static const String _startRecordingEvent = AppUrls.startRecording;
static const String _stopRecordingEvent = AppUrls.stopRecording;

final List<String> recordingEvents = const [
AppUrls.acquire,
AppUrls.startRecording,
AppUrls.stopRecording,
'recording_acquired',
'recording_started',
'recording_done',
'recording_finished',
'recorded',
'video',
'file',
'live_session_recorded',
'session_recorded',
'end_session',
];

void _init() {
print('🔧 [SocketProvider] _init() called');

socket ??= IO.io(AppUrls.socketUrl, <String, dynamic>{
'autoConnect': false,
'transports': ['websocket'],
'reconnection': true,
'reconnectionAttempts': 10,
'reconnectionDelay': 500,
});

print('✅ [SocketProvider] Socket created: ${AppUrls.socketUrl}');
}

void connectToSocket() {
print('🔄 [SocketProvider] connectToSocket()');

if (socket == null) {
_init();
}

if (!_baseListenersRegistered) {
_registerBaseListeners();
_baseListenersRegistered = true;
}

registerSocketDebugLogger();

if (socket!.connected) {
print('✅ [SocketProvider] Socket already connected');
return;
}

socket!.connect();
print('📡 [SocketProvider] socket.connect() called');
}

void ensureConnected() {
if (socket == null) {
_init();
}

if (!_baseListenersRegistered) {
_registerBaseListeners();
_baseListenersRegistered = true;
}

registerSocketDebugLogger();

if (socket!.disconnected) {
print('⚠️ [SocketProvider] Socket disconnected, connecting...');
socket!.connect();
}
}

void _registerBaseListeners() {
if (socket == null) return;

socket!.onConnect((data) async {
print('🎉 [SocketProvider] onConnect SUCCESS');
print('📊 [SocketProvider] Connected data: $data');
print('🆔 [SocketProvider] Socket ID: ${socket?.id}');

joinToMarket();

ChatProvider chatProvider = getIt();
List<int> roomIds = await chatProvider.getAllRoomsIds();

print('📋 [SocketProvider] rooms count: ${roomIds.length}');

if (roomIds.isNotEmpty) {
joinToAllRooms(roomIds);
}
});

socket!.onDisconnect((data) {
print('❌ [SocketProvider] onDisconnect: $data');
});

socket!.onConnectError((data) {
print('🚨 [SocketProvider] onConnectError: $data');
});

socket!.onError((data) {
print('🚨 [SocketProvider] onError: $data');
});

listenToNewMessage();
}

void disconnectToSocket() {
print('🔌 [SocketProvider] disconnectToSocket()');

if (socket == null || socket!.disconnected) {
print('⚠️ [SocketProvider] Socket already disconnected');
return;
}

leaveAllRooms();

socket!.disconnect();
socket = null;
ids = {};
_baseListenersRegistered = false;
_socketDebugRegistered = false;

print('🧹 [SocketProvider] cleaned');
}

void joinToAllRooms(List<num> ids) {
this.ids = Set.of(ids);

if (socket == null) {
print('❌ [SocketProvider] Cannot join rooms - socket null');
return;
}

final data = jsonEncode(ids);

emitSocketLogged(AppUrls.socketJoinRooms, data);

print('📤 [SocketProvider] join rooms event=${AppUrls.socketJoinRooms}');
print('📤 [SocketProvider] data=$data');
}

void leaveAllRooms() {
if (ids.isEmpty) {
print('ℹ️ [SocketProvider] No rooms to leave');
return;
}

if (socket == null) {
print('❌ [SocketProvider] Cannot leave rooms - socket null');
return;
}

final data = jsonEncode(ids.toList());

emitSocketLogged(AppUrls.socketLeaveRooms, data);

print('📤 [SocketProvider] leave rooms event=${AppUrls.socketLeaveRooms}');
print('📤 [SocketProvider] data=$data');
}

void joinToRoom(num id) {
if (socket == null) {
print('❌ [SocketProvider] Cannot join room - socket null');
return;
}

ids.add(id);

final data = jsonEncode([id]);

emitSocketLogged(AppUrls.socketJoinRooms, data);

print('📤 [SocketProvider] join room $id');
}

void joinToMarket() {
ProfileProvider profileProvider = getIt();
UserModel? userModel = profileProvider.getUserModel();

if (userModel == null) {
print('⚠️ [SocketProvider] UserModel null');
return;
}

if (socket == null) {
print('❌ [SocketProvider] Cannot join market - socket null');
return;
}

final marketId = userModel.providerModel?.mainAccount?.id;
final data = jsonEncode(marketId);

emitSocketLogged(AppUrls.socketJoinMarket, data);

print('📤 [SocketProvider] join market event=${AppUrls.socketJoinMarket}');
print('📤 [SocketProvider] market id=$marketId');
}

void sendMessageUserLevel(RoomModel room) {
if (socket == null) {
print('❌ [SocketProvider] Cannot send first message - socket null');
return;
}

joinToRoom(room.id!);

final data = jsonEncode(room.toJson());

emitSocketLogged(AppUrls.socketSendFirstMessage, data);

print('📤 [SocketProvider] first message sent');
}

void sendMessageRoomLevel(MessageModel messageModel) {
if (socket == null) {
print('❌ [SocketProvider] Cannot send message - socket null');
return;
}

final data = jsonEncode(messageModel.toJson());

emitSocketLogged(AppUrls.socketSendMessage, data);

print('📤 [SocketProvider] message sent');
}

void listenToNewMessage() {
if (socket == null) {
print('⚠️ [SocketProvider] Socket null, cannot listen');
return;
}

ChatProvider chatProvider = getIt();

socket!.on(AppUrls.socketReceiveFirstMessage, (data) async {
_printSocketLog(
title: 'INCOMING CHAT FIRST MESSAGE',
event: AppUrls.socketReceiveFirstMessage,
response: data,
source: 'event',
);

try {
RoomModel roomModel = RoomModel.fromJson(data);

joinToRoom(roomModel.id!);

chatProvider.onNewMessage(roomModel.latest_message!);
chatProvider.onNewRoomCreated(roomModel);
} catch (e, stack) {
print('❌ [SocketProvider] first message parse error: $e');
print(stack);
}
});

socket!.on(AppUrls.socketReceiveMessage, (data) {
_printSocketLog(
title: 'INCOMING CHAT MESSAGE',
event: AppUrls.socketReceiveMessage,
response: data,
source: 'event',
);

try {
MessageModel messageModel = MessageModel.fromJson(data);

if (messageModel.sender == 'user') {
chatProvider.onNewMessage(messageModel);
}
} catch (e, stack) {
print('❌ [SocketProvider] message parse error: $e');
print(stack);
}
});
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////// SOCKET DEBUG ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

String _prettySocketData(dynamic data) {
if (data == null) return 'null';

try {
return const JsonEncoder.withIndent('  ').convert(data);
} catch (_) {
return data.toString();
}
}

void _printSocketLog({
required String title,
required String event,
dynamic payload,
dynamic response,
String? source,
}) {
print('╔════════════════ SOCKET DEBUG ════════════════');
print('║ TITLE  => $title');
print('║ EVENT  => $event');

if (source != null) {
print('║ SOURCE => $source');
}

if (payload != null) {
print('║ PAYLOAD TYPE => ${payload.runtimeType}');
print('║ PAYLOAD => ${_prettySocketData(payload)}');
}

if (response != null) {
print('║ RESPONSE TYPE => ${response.runtimeType}');
print('║ RESPONSE => ${_prettySocketData(response)}');
}

print('║ SOCKET EXISTS => ${socket != null}');
print('║ SOCKET CONNECTED => ${socket?.connected}');
print('║ SOCKET ID => ${socket?.id}');
print('╚══════════════════════════════════════════════');
}

void registerSocketDebugLogger() {
if (socket == null) return;

if (_socketDebugRegistered) {
return;
}

_socketDebugRegistered = true;

socket!.onAny((event, data) {
_printSocketLog(
title: 'INCOMING SOCKET EVENT',
event: event,
response: data,
source: 'onAny',
);
});

print('✅ Socket debug logger registered');
}

void emitSocketLogged(
String event,
dynamic payload,
) {
if (socket == null) {
print('❌ Cannot emit $event because socket is null');
return;
}

_printSocketLog(
title: 'OUTGOING SOCKET EMIT',
event: event,
payload: payload,
);

socket!.emit(event, payload);
}

Future<dynamic> emitSocketWithAckLogged({
required String event,
required dynamic payload,
Duration timeout = const Duration(seconds: 20),
}) async {
ensureConnected();

if (socket == null) {
print('❌ Cannot emit $event because socket is null');
return null;
}

final completer = Completer<dynamic>();

void emitNow() {
_printSocketLog(
title: 'OUTGOING SOCKET EMIT WITH ACK',
event: event,
payload: payload,
);

try {
socket!.emitWithAck(
event,
payload,
ack: (data) {
_printSocketLog(
title: 'SOCKET ACK RESPONSE',
event: event,
payload: payload,
response: data,
source: 'ack',
);

if (!completer.isCompleted) {
completer.complete(data);
}
},
);
} catch (e) {
_printSocketLog(
title: 'SOCKET EMIT WITH ACK ERROR',
event: event,
payload: payload,
response: e.toString(),
source: 'catch',
);

socket!.emit(event, payload);
}
}

if (socket!.connected) {
emitNow();
} else {
print('⚠️ Socket not connected. Waiting before emit $event');

socket!.once('connect', (_) {
print('✅ Socket connected. Emit now: $event');
emitNow();
});
}

return await completer.future.timeout(
timeout,
onTimeout: () {
_printSocketLog(
title: 'SOCKET ACK TIMEOUT',
event: event,
payload: payload,
response: 'No ACK response received within ${timeout.inSeconds}s',
source: 'timeout',
);

return null;
},
);
}

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// LIVE RECORDING //////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

String _toFormEncoded(Map<String, dynamic> map) {
final Map<String, String> stringMap = {};

map.forEach((key, value) {
if (value != null) {
stringMap[key] = value.toString();
}
});

return Uri(queryParameters: stringMap).query;
}

Map<String, dynamic>? _asMap(dynamic value) {
if (value == null) return null;

if (value is Map<String, dynamic>) {
return value;
}

if (value is Map) {
return Map<String, dynamic>.from(value);
}

if (value is String) {
final text = value.trim();

if (text.isEmpty) return null;

try {
final decoded = jsonDecode(text);

if (decoded is Map<String, dynamic>) {
return decoded;
}

if (decoded is Map) {
return Map<String, dynamic>.from(decoded);
}
} catch (_) {}

if (text.contains('=')) {
try {
return Map<String, dynamic>.from(Uri.splitQueryString(text));
} catch (_) {}
}
}

return null;
}

String? _findStringByKeys(
dynamic value,
List<String> keys,
) {
if (value == null) return null;

if (value is List) {
for (final item in value) {
final found = _findStringByKeys(item, keys);

if (found != null && found.trim().isNotEmpty) {
return found;
}
}

return null;
}

final map = _asMap(value);

if (map == null) return null;

for (final key in keys) {
final directValue = map[key];

if (directValue != null && directValue.toString().trim().isNotEmpty) {
return directValue.toString();
}
}

for (final entry in map.entries) {
final nestedValue = entry.value;

if (nestedValue is Map ||
nestedValue is String ||
nestedValue is List) {
final found = _findStringByKeys(nestedValue, keys);

if (found != null && found.trim().isNotEmpty) {
return found;
}
}
}

return null;
}

bool _hasAnyKeyValue(dynamic data, List<String> keys) {
final value = _findStringByKeys(data, keys);
return value != null && value.trim().isNotEmpty;
}

bool _isRelevantRecordingAnyEvent({
required String eventName,
required String label,
required List<String> responseEvents,
}) {
final event = eventName.toLowerCase();

for (final responseEvent in responseEvents) {
if (event == responseEvent.toLowerCase()) {
return true;
}
}

if (label == 'ACQUIRE') {
return event.contains('acquire') ||
event.contains('resource') ||
event.contains('record');
}

if (label == 'START') {
return event.contains('start') ||
event.contains('sid') ||
event.contains('record');
}

if (label == 'STOP' || label == 'END') {
return event.contains('stop') ||
event.contains('end') ||
event.contains('done') ||
event.contains('finish') ||
event.contains('record') ||
event.contains('video') ||
event.contains('file');
}

return false;
}

Future<dynamic> _emitFormEncodedAndWaitForRequiredValue({
required String label,
required String event,
required Map<String, dynamic> payloadMap,
required List<String> responseEvents,
required List<String> requiredKeys,
Duration timeout = const Duration(seconds: 20),
}) async {
ensureConnected();

if (socket == null) return null;

final String formPayload = _toFormEncoded(payloadMap);

final completer = Completer<dynamic>();
dynamic lastResponse;

void handleResponse(dynamic data, String source, String responseEvent) {
lastResponse = data;

_printSocketLog(
title: '$label RESPONSE',
event: responseEvent,
payload: formPayload,
response: data,
source: source,
);

if (_hasAnyKeyValue(data, requiredKeys) && !completer.isCompleted) {
completer.complete(data);
}
}

for (final responseEvent in responseEvents) {
socket!.on(responseEvent, (data) {
handleResponse(data, 'event', responseEvent);
});
}

void anyEventPrinter(String eventName, dynamic data) {
if (_isRelevantRecordingAnyEvent(
eventName: eventName,
label: label,
responseEvents: responseEvents,
)) {
handleResponse(data, 'onAny', eventName);
}
}

socket!.onAny(anyEventPrinter);

void emitNow() {
_printSocketLog(
title: 'EMIT $label FORM-ENCODED',
event: event,
payload: formPayload,
);

print('========== $label FORM ENCODED PAYLOAD ==========');
print(formPayload);
print('=================================================');

try {
socket!.emitWithAck(
event,
formPayload,
ack: (data) {
handleResponse(data, 'ack', event);
},
);
} catch (e) {
_printSocketLog(
title: 'EMIT $label WITH ACK ERROR',
event: event,
payload: formPayload,
response: e.toString(),
source: 'catch',
);

socket!.emit(event, formPayload);
}
}

if (socket!.connected) {
emitNow();
} else {
print('Socket not connected. Waiting connect for $label...');

socket!.once('connect', (_) {
print('Socket connected. Emit $label now.');
emitNow();
});
}

try {
final result = await completer.future.timeout(
timeout,
onTimeout: () {
_printSocketLog(
title: '$label TIMEOUT',
event: event,
payload: formPayload,
response:
'No required value returned. Required keys: $requiredKeys. Last response: $lastResponse',
source: 'timeout',
);

return null;
},
);

_printSocketLog(
title: '$label FINAL RESULT',
event: event,
payload: formPayload,
response: result,
source: 'final',
);

return result;
} finally {
for (final responseEvent in responseEvents) {
socket!.off(responseEvent);
}

socket!.offAny(anyEventPrinter);
}
}

Future<dynamic> _emitFormEncodedAndWaitAnyResponse({
required String label,
required String event,
required Map<String, dynamic> payloadMap,
required List<String> responseEvents,
Duration timeout = const Duration(seconds: 20),
}) async {
ensureConnected();

if (socket == null) return null;

final String formPayload = _toFormEncoded(payloadMap);

final completer = Completer<dynamic>();
dynamic lastResponse;

void handleResponse(dynamic data, String source, String responseEvent) {
lastResponse = data;

_printSocketLog(
title: '$label RESPONSE',
event: responseEvent,
payload: formPayload,
response: data,
source: source,
);

if (!completer.isCompleted) {
completer.complete(data);
}
}

for (final responseEvent in responseEvents) {
socket!.on(responseEvent, (data) {
handleResponse(data, 'event', responseEvent);
});
}

void anyEventPrinter(String eventName, dynamic data) {
if (_isRelevantRecordingAnyEvent(
eventName: eventName,
label: label,
responseEvents: responseEvents,
)) {
handleResponse(data, 'onAny', eventName);
}
}

socket!.onAny(anyEventPrinter);

void emitNow() {
_printSocketLog(
title: 'EMIT $label FORM-ENCODED',
event: event,
payload: formPayload,
);

print('========== $label FORM ENCODED PAYLOAD ==========');
print(formPayload);
print('=================================================');

try {
socket!.emitWithAck(
event,
formPayload,
ack: (data) {
handleResponse(data, 'ack', event);
},
);
} catch (e) {
_printSocketLog(
title: 'EMIT $label WITH ACK ERROR',
event: event,
payload: formPayload,
response: e.toString(),
source: 'catch',
);

socket!.emit(event, formPayload);
}
}

if (socket!.connected) {
emitNow();
} else {
socket!.once('connect', (_) {
emitNow();
});
}

try {
return await completer.future.timeout(
timeout,
onTimeout: () {
_printSocketLog(
title: '$label TIMEOUT',
event: event,
payload: formPayload,
response: 'Node did not return anything. Last response: $lastResponse',
source: 'timeout',
);

return null;
},
);
} finally {
for (final responseEvent in responseEvents) {
socket!.off(responseEvent);
}

socket!.offAny(anyEventPrinter);
}
}

Future<Map<String, dynamic>?> startRecording({
required num sessionId,
required String channelName,
required int uid,
String mode = 'mix',
}) async {
ensureConnected();

if (socket == null) return null;

////////////////////////////////////////////////////////////////////////////
// STEP 1: ACQUIRE
////////////////////////////////////////////////////////////////////////////

final acquirePayload = {
'session_id': sessionId,
'channel': channelName,
'channel_name': channelName,
'cname': channelName,
'uid': uid,
'mode': mode,
};

print('========== CLOUD RECORDING FLOW START ==========');
print('STEP 1 => ACQUIRE');
print('EVENT => ${AppUrls.acquire}');
print('CHANNEL => $channelName');
print('UID => $uid');
print('MODE => $mode');
print('===============================================');

final dynamic acquireResponse =
await _emitFormEncodedAndWaitForRequiredValue(
label: 'ACQUIRE',
event: AppUrls.acquire,
payloadMap: acquirePayload,
responseEvents: const [
AppUrls.acquire,
'recording_acquired',
'recording_acquire',
'acquire_done',
'resource_acquired',
'acquired',
'recording_resource',
'resource',
'resourceId',
],
requiredKeys: const [
'resourceId',
'resource_id',
'resource',
],
timeout: const Duration(seconds: 20),
);

final String? resourceId = _findStringByKeys(
acquireResponse,
const [
'resourceId',
'resource_id',
'resource',
],
);

print('========== ACQUIRE EXTRACT ==========');
print('ACQUIRE RAW => $acquireResponse');
print('RESOURCE ID => $resourceId');
print('====================================');

if (resourceId == null || resourceId.trim().isEmpty) {
print('ACQUIRE FAILED: resourceId is missing');
return null;
}

////////////////////////////////////////////////////////////////////////////
// STEP 2: START
////////////////////////////////////////////////////////////////////////////
// resourceId اللي رجع من acquire بيتبعت هنا عشان start يرجع sid.

final startPayload = {
'session_id': sessionId,
'channel': channelName,
'channel_name': channelName,
'cname': channelName,
'uid': uid,
'mode': mode,

// بعت الثلاثة عشان Node يقرأ الاسم اللي متوقعه.
'resourceId': resourceId,
'resource_id': resourceId,
'resource': resourceId,
};

print('========== CLOUD RECORDING FLOW CONTINUE ==========');
print('STEP 2 => START');
print('EVENT => ${AppUrls.startRecording}');
print('CHANNEL => $channelName');
print('UID => $uid');
print('MODE => $mode');
print('RESOURCE ID SENT TO START => $resourceId');
print('==================================================');

final dynamic startResponse =
await _emitFormEncodedAndWaitForRequiredValue(
label: 'START',
event: AppUrls.startRecording,
payloadMap: startPayload,
responseEvents: const [
AppUrls.startRecording,
'recording_started',
'recording_start',
'start_done',
'recording_start_done',
'recording_started_success',
'sid_created',
'recording_sid',
'cloud_recording_started',
'sid',
],
requiredKeys: const [
'sid',
],
timeout: const Duration(seconds: 20),
);

final String? sid = _findStringByKeys(
startResponse,
const [
'sid',
],
);

print('========== START EXTRACT ==========');
print('START RAW => $startResponse');
print('SID => $sid');
print('==================================');

if (sid == null || sid.trim().isEmpty) {
print('START FAILED: sid is missing');
return null;
}

final result = {
'resourceId': resourceId,
'resource': resourceId,
'resource_id': resourceId,
'sid': sid,
'channel': channelName,
'channel_name': channelName,
'uid': uid,
'mode': mode,
'acquireRaw': acquireResponse,
'startRaw': startResponse,
};

print('========== CLOUD RECORDING START FINAL ==========');
print('RESULT => $result');
print('================================================');

return result;
}

Future<String?> stopRecordingAndWaitVideo({
required num sessionId,
required String channelName,
required int uid,
required String resourceId,
required String sid,
String mode = 'mix',
}) async {
ensureConnected();

final payload = {
'session_id': sessionId,
'channel': channelName,
'channel_name': channelName,
'cname': channelName,
'uid': uid,
'mode': mode,
'resourceId': resourceId,
'resource_id': resourceId,
'resource': resourceId,
'sid': sid,
};

print('========== STOP RECORDING AND WAIT VIDEO ==========');
print('EVENT => ${AppUrls.stopRecording}');
print('RESOURCE ID => $resourceId');
print('SID => $sid');
print('==================================================');

final dynamic response = await _emitFormEncodedAndWaitAnyResponse(
label: 'STOP',
event: AppUrls.stopRecording,
payloadMap: payload,
responseEvents: const [
AppUrls.stopRecording,
'end',
'stop',
'recording_done',
'recording_finished',
'recorded',
'video',
'file',
'live_session_recorded',
'session_recorded',
'end_session',
],
timeout: const Duration(seconds: 20),
);

final String video = extractVideoName(response);

print('========== STOP VIDEO EXTRACT ==========');
print('STOP RAW => $response');
print('VIDEO => $video');
print('=======================================');

if (video.isEmpty) return null;

return video;
}

Future<dynamic> endRecording({
required String channelName,
required int uid,
required String resourceId,
required String sid,
String mode = 'mix',
num? sessionId,
}) async {
ensureConnected();

final payload = <String, dynamic>{
'channel': channelName,
'channel_name': channelName,
'cname': channelName,
'uid': uid,
'mode': mode,
'resourceId': resourceId,
'resource_id': resourceId,
'resource': resourceId,
'sid': sid,
};

if (sessionId != null) {
payload['session_id'] = sessionId;
}

print('========== SOCKET END RECORDING REQUEST ==========');
print('EVENT => ${AppUrls.stopRecording}');
print('RESOURCE ID => $resourceId');
print('SID => $sid');
print('=================================================');

final dynamic result = await _emitFormEncodedAndWaitAnyResponse(
label: 'END',
event: AppUrls.stopRecording,
payloadMap: payload,
responseEvents: const [
AppUrls.stopRecording,
'end',
'stop',
'recording_done',
'recording_finished',
'recorded',
'video',
'file',
'live_session_recorded',
'session_recorded',
'end_session',
],
timeout: const Duration(seconds: 20),
);

print('========== SOCKET END FINAL RESULT ==========');
print('RESULT => $result');
print('============================================');

return result;
}

String extractVideoName(dynamic response) {
dynamic parsed = response;

if (response == null) return "";

if (response is String) {
final text = response.trim();

try {
parsed = jsonDecode(text);
} catch (_) {
if (text.contains('=')) {
try {
parsed = Uri.splitQueryString(text);
} catch (_) {}
} else if (text.endsWith(".mp4") ||
text.endsWith(".m3u8") ||
text.startsWith("http")) {
return _normalizeVideoName(text);
} else {
return "";
}
}
}

String video = "";

if (parsed is Map) {
video =
parsed["video"]?.toString() ??
parsed["video_name"]?.toString() ??
parsed["file"]?.toString() ??
parsed["file_name"]?.toString() ??
parsed["recording"]?.toString() ??
parsed["recording_url"]?.toString() ??
parsed["url"]?.toString() ??
"";

if (video.isEmpty && parsed["data"] is Map) {
final nested = parsed["data"] as Map;

video =
nested["video"]?.toString() ??
nested["video_name"]?.toString() ??
nested["file"]?.toString() ??
nested["file_name"]?.toString() ??
nested["recording"]?.toString() ??
nested["recording_url"]?.toString() ??
nested["url"]?.toString() ??
"";
}

if (video.isEmpty) {
video = _findStringByKeys(
parsed,
const [
'video',
'video_name',
'file',
'file_name',
'recording',
'recording_url',
'url',
],
) ??
"";
}
}

return _normalizeVideoName(video);
}

String _normalizeVideoName(String video) {
video = video.trim();

if (video.isEmpty) return "";

if (video.startsWith("http")) {
final uri = Uri.tryParse(video);

if (uri != null && uri.pathSegments.isNotEmpty) {
return uri.pathSegments.last;
}
}

return video;
}
}
