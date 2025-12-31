

using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;

[ApiController]
[Route("api")]
public class HelloController : ControllerBase
{
	[HttpGet("hello")]
	public IActionResult GetHello([FromQuery] string? name)
	{
		var msg = string.IsNullOrWhiteSpace(name)
			? "Hello, world!"
			: $"Hello, {name.Trim()}!";
		return Ok(new ApiResponse { Success = true, Message = msg });
	}

	[HttpPost("greet")]
	public IActionResult PostGreet([FromBody] GreetRequest request)
	{
		if (!ModelState.IsValid)
			return BadRequest(new ApiResponse { Success = false, Message = "Name is required and must be 2+ chars." });
		return Ok(new ApiResponse { Success = true, Message = $"Hello, {request.Name.Trim()}!" });
	}

	[HttpGet("health")]
	public IActionResult Health() => Ok(new { status = "ok" });
}

public class GreetRequest
{
	[Required, MinLength(2)]
	public string Name { get; set; }
}

public class ApiResponse
{
	public bool Success { get; set; }
	public string Message { get; set; }
}
