def lambda_handler(event, context):
    return f"hello from {context.function_name}"
