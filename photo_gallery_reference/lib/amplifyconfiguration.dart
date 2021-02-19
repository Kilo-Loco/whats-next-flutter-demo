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
                            "PoolId": "us-west-2:61718fe9-bfda-47e8-bf6d-c648df7cb122",
                            "Region": "us-west-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-west-2_4beIHThwH",
                        "AppClientId": "2h1ugp9isq8tvirqbbadql3ftq",
                        "Region": "us-west-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "photogalleryreferencdce3bfa3-dce3bfa3-dev.auth.us-west-2.amazoncognito.com",
                            "AppClientId": "2h1ugp9isq8tvirqbbadql3ftq",
                            "SignInRedirectURI": "galleryapp://",
                            "SignOutRedirectURI": "galleryapp://",
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
                        "Bucket": "photogalleryreferenc92a3b101d44d4897a883da21fb723326-dev",
                        "Region": "us-west-2"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "photogalleryreferenc92a3b101d44d4897a883da21fb723326-dev",
                "region": "us-west-2",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';