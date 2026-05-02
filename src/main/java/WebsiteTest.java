import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

void main() throws Exception {
    String url = "http://th.if.uj.edu.pl/";
    String test = "Institute of Theoretical Physics";

    IO.println("Testing: " + url);

    try (HttpClient client = HttpClient.newHttpClient()) {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(
                request,
                HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            IO.println("Status code: " + response.statusCode());
            System.exit(1);
        }

        String type = response.headers()
                .firstValue("Content-Type")
                .orElse("");

        if (!type.contains("text/html")) {
            IO.println("Response type: " + type);
            System.exit(2);
        }

        if (!response.body().contains(test)) {
            IO.println("Incorrect response body");
            System.exit(3);
        }

        IO.println("Status: " + response.statusCode());
        IO.println("Response type: " + type);
        IO.println("Website is working correctly!");
        System.exit(0);

    } catch (Exception e) {
        IO.println("Error: " + e.getMessage());
        System.exit(4);
    }
}
