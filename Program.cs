using System;
using System.Net.Http;
using System.Net.Security;
using System.Threading.Tasks;

class Program
{
    static HttpClientHandler GetCustomHandler()
    {
        var handler = new HttpClientHandler();

        handler.ClientCertificateOptions = ClientCertificateOption.Manual;

        handler.ServerCertificateCustomValidationCallback = (httpRequestMessage, cert, cetChain, policyErrors) =>
        {
            if (policyErrors == SslPolicyErrors.None)
            {
                Console.WriteLine($"Certificate validation - no errors.");
                return true;
            }

            Console.WriteLine($"Server certificate validation failed, policyErrors={policyErrors}:");
            return false;
        };

        return handler;
    }

    static async Task RunRequest(string url)
    {
        var httpClient = new HttpClient(GetCustomHandler());
        Console.WriteLine($"Sending request to {url}");
        try
        {
            var result = await httpClient.GetAsync(url);

            Console.WriteLine("Received:");
            Console.WriteLine(result);
            Console.WriteLine("#################################################################");
            Console.WriteLine(result.Headers);
            Console.WriteLine("#################################################################");
            Console.WriteLine(await result.Content.ReadAsStringAsync());
        }
        catch (Exception e)
        {
            Console.WriteLine("Failed with Exception:");
            Console.WriteLine("#################################################################");
            Console.WriteLine(e);
        }
    }

    static async Task Main(string[] args)
    {
        var url = args.Length > 0 ? args[0] : "https://letsencrypt.org/";
        await RunRequest(url);
    }
}