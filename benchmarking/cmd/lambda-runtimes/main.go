package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
	"sync"

	awsconfig "github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/klemjul/aws-benchmarking-experiments/benchmarking/internal"
	"github.com/olekukonko/tablewriter"
)

func main() {
	configFilePath := flag.String("config", "config.json", "Path to the configuration file")
	flag.Parse()

	file, err := os.Open(*configFilePath)
	if err != nil {
		log.Fatalf("Error opening config file: %v", err)
	}
	defer file.Close()

	fileContent, err := io.ReadAll(file)
	if err != nil {
		log.Fatalf("Error reading config file: %v", err)
	}

	var config Config
	err = json.Unmarshal(fileContent, &config)
	if err != nil {
		log.Fatalf("Error parsing config file: %v", err)
	}

	sdkConfig, err := awsconfig.LoadDefaultConfig(context.TODO())
	if err != nil {
		fmt.Println("Couldn't load default configuration. Have you set up your AWS account?")
		fmt.Println(err)
		return
	}
	lambdaClient := lambda.NewFromConfig(sdkConfig)

	results := make(chan internal.Result[internal.InvokeLambdaTimedOutput], len(config.Lambdas))
	var wg sync.WaitGroup

	for i := 0; i < len(config.Lambdas); i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			err := internal.ForceLambdaColdStart(context.TODO(), lambdaClient, config.Lambdas[i].FunctionName)
			if err != nil {
				fmt.Printf("%s Failed to ForceLambdaColdStart for lambda, %v \n", config.Lambdas[i].FunctionName, err)
			}
			results <- internal.InvokeLambdaTimed(context.TODO(), lambdaClient, config.Lambdas[i].FunctionName, nil)
		}()
	}

	wg.Wait()
	close(results)

	table := tablewriter.NewWriter(os.Stdout)
	table.SetHeader([]string{"FunctionName", "SdkDuration", "Duration", "InitDuration", "Duration", "MaxMemoruUsed"})
	for result := range results {
		fnType := strings.Split(result.Value.FunctionName, "aws-benchmarking-experiments-")

		if result.Error != nil {
			fmt.Println(result.Error)
			table.Append([]string{fnType[1], result.Value.SdkDuration, result.Value.Duration})
		} else {
			table.Append([]string{fnType[1], result.Value.SdkDuration, result.Value.Duration, result.Value.InitDuration, result.Value.Duration, result.Value.MaxMemoryUsed})
		}
	}
	table.Render()
}
