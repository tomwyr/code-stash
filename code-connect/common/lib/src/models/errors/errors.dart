import '../../utils/sealed.dart';

part 'team_finder.dart';

sealed class AppError {}

class OtherError extends AppError {}
