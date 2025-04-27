import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
// import * as sqs from 'aws-cdk-lib/aws-sqs';


import { Stack, StackProps } from 'aws-cdk/lib';
import { Function, Runtime } from 'aws-cdk/lib/aws-lambda';
import { Api, RestApi } from 'aws-cdk/lib/aws-apigateway';

export class HelloWorldStack extends Stack {
  constructor(scope: StackProps) {
    super(scope);

    // Define a Lambda function
    const helloFunction = new Function(this, 'HelloHandler', {
      runtime: Runtime.NODEJS_14_X, 
      code: Function.fromAsset('lambda'),
      handler: 'index.handler'
    });

    // Define an API Gateway endpoint that calls the Lambda function
    const helloApi = new Api(this, 'HelloApi', {
      restApi: new RestApi(this, 'Hello', {
        defaultCorsPreflightOptions: {
          allowOrigins: Api.ALL_ORIGINS,
        }
      })
    });

    helloApi.root.addMethod('GET', new LambdaIntegration(helloFunction));
  }
}
