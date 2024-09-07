package internal

// Result represents the result of an operation, including a value and an error
type Result[T any] struct {
	Value T
	Error error
}
