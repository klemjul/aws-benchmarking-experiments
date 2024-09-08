package internal

import (
	"context"
	"encoding/base64"
	"fmt"
	"log"
	"regexp"
	"time"

	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/aws/aws-sdk-go-v2/service/lambda/types"
	"github.com/google/uuid"
)

type InvokeLambdaTimedOutput struct {
	FunctionName   string
	Response       string
	SdkDuration    string
	InitDuration   string
	BilledDuration string
	Duration       string
	MaxMemoryUsed  string
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
		LogType:      "Tail",
	})
	duration := time.Since(startTime)
	durationMs := duration.Milliseconds()

	if err != nil {
		return Result[InvokeLambdaTimedOutput]{
			Error: fmt.Errorf("failed to invoke lambda function: %w", err),
			Value: InvokeLambdaTimedOutput{
				FunctionName: functionName,
			},
		}
	}

	if result.FunctionError != nil {
		return Result[InvokeLambdaTimedOutput]{
			Error: fmt.Errorf("lambda function returned an error: %s", *result.FunctionError),
			Value: InvokeLambdaTimedOutput{
				SdkDuration:  fmt.Sprintf("%v ms", durationMs),
				FunctionName: functionName,
			},
		}
	}

	// Decode the base64-encoded LogResult
	if result.LogResult == nil {
		log.Fatalf("LogResult is nil, %v", result.LogResult)
	}
	logResult, err := base64.StdEncoding.DecodeString(*result.LogResult)
	if err != nil {
		log.Fatalf("failed to decode LogResult, %v", err)
	}

	metrics := ExtractLambdaResultMetrics(string(logResult))

	return Result[InvokeLambdaTimedOutput]{
		Value: InvokeLambdaTimedOutput{
			Response:       string(result.Payload),
			SdkDuration:    fmt.Sprintf("%v ms", durationMs),
			FunctionName:   functionName,
			InitDuration:   fmt.Sprintf("%v ms", metrics["init_duration"]),
			MaxMemoryUsed:  fmt.Sprintf("%v MB", metrics["max_memory_used"]),
			BilledDuration: fmt.Sprintf("%v ms", metrics["billed_duration"]),
			Duration:       fmt.Sprintf("%v ms", metrics["duration"]),
		},
	}
}

// extractMetrics uses regular expressions to parse the Lambda log result and extract key metrics.
func ExtractLambdaResultMetrics(log string) map[string]string {
	metrics := make(map[string]string)

	// Define regex patterns for the metrics
	regexPatterns := map[string]string{
		"init_duration":   `Init Duration: ([\d\.]+) ms`,
		"max_memory_used": `Max Memory Used: (\d+) MB`,
		"duration":        `Duration: ([\d\.]+) ms`,
		"billed_duration": `Billed Duration: (\d+) ms`,
	}

	// Loop through each regex pattern and extract the matched value
	for metric, pattern := range regexPatterns {
		re := regexp.MustCompile(pattern)
		match := re.FindStringSubmatch(log)
		if len(match) > 1 {
			metrics[metric] = match[1]
		} else {
			metrics[metric] = "-"
		}
	}

	return metrics
}
