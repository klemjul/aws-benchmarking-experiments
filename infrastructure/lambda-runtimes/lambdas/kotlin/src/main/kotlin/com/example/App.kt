package com.example

import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestHandler

// Define the function handler
fun handleRequest(event: Map<String, String>, context: Context): String {
    return "hello from " + context.functionName
}
