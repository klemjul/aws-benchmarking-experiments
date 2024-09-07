package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

func HandleRequest(ctx context.Context, event any) (string, error) {
	return fmt.Sprintf("hello from %s", lambdacontext.FunctionName), nil
}

func main() {
	lambda.Start(HandleRequest)
}
