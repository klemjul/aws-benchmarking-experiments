import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.Map;

public class App implements RequestHandler<Map<String,String>, String>{

  @Override
  public String handleRequest(Map<String,String> event, Context context)
  {
    return "hello from " + context.getFunctionName();
  }
}