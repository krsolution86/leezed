import {
    AuthServiceConfig,
    FacebookLoginProvider,
    GoogleLoginProvider
} from 'angular-6-social-login';

export function getAuthServiceConfigs() {
    // var config={facebookConfig:{},googleConfig:{}};
    // config.facebookConfig = new AuthServiceConfig([
    //     {
    //         id: FacebookLoginProvider.PROVIDER_ID,
    //         provider: new FacebookLoginProvider('2334958963382261')
    //     }
    // ]);
    // config.googleConfig = 
  

    let config = new AuthServiceConfig(
        [
          {
            id: FacebookLoginProvider.PROVIDER_ID,
            provider:new FacebookLoginProvider('2334958963382261')
          },
          {
            id: GoogleLoginProvider.PROVIDER_ID,
            provider: new GoogleLoginProvider('888196419121-kdtf3o693kpokll78qtrq5diu0c37180.apps.googleusercontent.com')
          }
        ]
    );
    return config;
   
}