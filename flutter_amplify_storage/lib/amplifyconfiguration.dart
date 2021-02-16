const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-west-2:ec78c122-9b61-4259-871c-e0e108abeaa2",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_HovbYNvWq",
                        "AppClientId": "2ej4i7cnjudeap63s1fnamru7l",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "flutteramplifystorag28eae8c4-28eae8c4-dev.auth.us-west-2.amazoncognito.com",
                            "AppClientId": "2ej4i7cnjudeap63s1fnamru7l",
                            "SignInRedirectURI": "gallery://",
                            "SignOutRedirectURI": "gallery://",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "flutteramplifystorag4472cfa5ec7640a2ab8a6e3aa01154322-dev",
                        "Region": "us-west-2"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "flutteramplifystorag4472cfa5ec7640a2ab8a6e3aa01154322-dev",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';