import 'dart:io';

const appDomainIOS = '127.0.0.1';
const appDomainAndroid = '10.0.2.2';
final appDomain = Platform.isIOS
    ? appDomainIOS
    : Platform.isAndroid
        ? appDomainAndroid
        : '';

const projectId = '621a8e19bc64d7f38fc9';
final projectEndpoint = 'http://$appDomain/v1';

final magicUrlCallbackUrl = 'appwrite-magic-url://$appDomain/magic-url-callback';
