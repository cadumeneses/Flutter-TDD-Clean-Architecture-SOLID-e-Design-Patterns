import '../../../../presentation/presenters/stream_login_presenter.dart';
import '../../../../ui/pages/login/login_presenter.dart';

import '../../factories.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
  );
}
