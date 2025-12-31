
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("[controller]")]
public class HelloController : ControllerBase
{
	[HttpGet("hello")]
	public IActionResult GetHello()
	{
		return Ok(new { message = "Hello, world!" });
	}

	[HttpPost("greet")]
	public IActionResult PostGreet([FromBody] GreetRequest request)
	{
		if (string.IsNullOrWhiteSpace(request.Name))
			return BadRequest(new { error = "Name is required" });
		return Ok(new { message = $"Hello, {request.Name}!" });
	}
}

public class GreetRequest
{
	public string Name { get; set; }
}
