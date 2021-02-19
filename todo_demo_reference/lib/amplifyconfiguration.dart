const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "WhatsNextTodoDemo": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://p4b6rnrxkna4hbt6i436xtiism.appsync-api.us-east-2.amazonaws.com/graphql",
                    "region": "us-east-2",
                    "authorizationType": "API_KEY",
                    "apiKey": "da2-p3mcajqqwjgbthdrfujpap26ey"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://p4b6rnrxkna4hbt6i436xtiism.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "API_KEY",
                        "ApiKey": "da2-p3mcajqqwjgbthdrfujpap26ey",
                        "ClientDatabasePrefix": "WhatsNextTodoDemo_API_KEY"
                    },
                    "WhatsNextTodoDemo_AWS_IAM": {
                        "ApiUrl": "https://p4b6rnrxkna4hbt6i436xtiism.appsync-api.us-east-2.amazonaws.com/graphql",
                        "Region": "us-east-2",
                        "AuthMode": "AWS_IAM",
                        "ClientDatabasePrefix": "WhatsNextTodoDemo_AWS_IAM"
                    }
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-2:9b114f41-573d-4a6e-ab3d-294bbe314486",
                            "Region": "us-east-2"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-2_QMN2iglzL",
                        "AppClientId": "418ealttush14nh76ha3t226vk",
                        "Region": "us-east-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                }
            }
        }
    }
}''';