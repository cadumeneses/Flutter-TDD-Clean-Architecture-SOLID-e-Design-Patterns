import '../../../../presentation/presenters/getx_login_presenter.dart';
import '../../../../ui/pages/login/login_presenter.dart';

import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeRemoteAuthentication(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
