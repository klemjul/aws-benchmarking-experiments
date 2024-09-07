package internal

import (
	"context"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/aws/aws-sdk-go-v2/service/lambda/types"
	"github.com/google/uuid"
)

type InvokeLambdaTimedOutput struct {
	FunctionName string
	Response     string
	Duration     time.Duration
}

func ForceLambdaColdStart(ctx context.Context, svc *lambda.Client, functionName string) error {
	lambdaEnvVars := map[string]string{
		"REDEPLOY_LAMBDA": uuid.New().String(),
	}

	_, err := svc.UpdateFunctionConfiguration(ctx, &lambda.UpdateFunctionConfigurationInput{
		Environment: &types.Environment{
			Variables: lambdaEnvVars,
		},
		FunctionName: &functionName,
	})
	time.Sleep(1000)
	return err
}

// InvokeLambdaTimed measures the time taken to invoke an AWS Lambda function and returns the response and duration.
func InvokeLambdaTimed(ctx context.Context, svc *lambda.Client, functionName string, payload []byte) (output Result[InvokeLambdaTimedOutput]) {
	startTime := time.Now()

	result, err := svc.Invoke(ctx, &lambda.InvokeInput{
		FunctionName: &functionName,
		Payload:      payload,
	})
	if err != nil {
		return Result[InvokeLambdaTimedOutput]{
			Error: fmt.Errorf("failed to invoke lambda function: %w", err),
			Value: InvokeLambdaTimedOutput{FunctionName: functionName},
		}
	}

	duration := time.Since(startTime)

	if result.FunctionError != nil {
		return Result[InvokeLambdaTimedOutput]{
			Error: fmt.Errorf("lambda function returned an error: %s", *result.FunctionError),
			Value: InvokeLambdaTimedOutput{
				Duration:     duration,
				FunctionName: functionName,
			},
		}
	}

	return Result[InvokeLambdaTimedOutput]{
		Value: InvokeLambdaTimedOutput{Response: string(result.Payload), Duration: duration, FunctionName: functionName},
	}
}
