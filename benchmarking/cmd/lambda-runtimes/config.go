package main

type Config struct {
	Lambdas []LambdaToBenchmark `json:"lambdas"`
}

type LambdaToBenchmark struct {
	FunctionName string `json:"functionName"`
}
