var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders();
builder.Logging.AddJsonConsole();
builder.Services.AddHealthChecks();
builder.Services.Configure<HostOptions>(options => options.ShutdownTimeout = TimeSpan.FromSeconds(20));

var app = builder.Build();
app.MapGet("/info", (IConfiguration config) => Results.Ok(new
{
    application = "aks-lab-api",
    version = config["APP_VERSION"] ?? "local",
    instance = Environment.MachineName,
    message = config["APP_MESSAGE"] ?? "Hello from .NET",
    utc = DateTimeOffset.UtcNow
}));
// No external dependencies yet: these check that the HTTP process can respond.
app.MapHealthChecks("/health/live");
app.MapHealthChecks("/health/ready");
app.Run();
