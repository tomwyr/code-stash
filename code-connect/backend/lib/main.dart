import 'api/listen.dart';
import 'utils/json_types.dart';

Future<void> main() async {
  registerJsonTypes();
  await listen();
}
