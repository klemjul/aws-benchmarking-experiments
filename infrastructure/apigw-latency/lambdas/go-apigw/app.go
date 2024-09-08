package main

import (
	"context"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/lambdacontext"
)

// Handler function for Lambda
func handler(request events.APIGatewayProxyRequest, context context.Context) (events.APIGatewayProxyResponse, error) {
	return events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: "hello from " + lambdacontext.FunctionName,
	}, nil
}

func main() {
	// Start the Lambda function
	lambda.Start(handler)
}
