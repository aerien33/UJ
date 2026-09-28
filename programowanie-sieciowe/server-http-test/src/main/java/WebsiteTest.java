import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class WebsiteTest {
    public static void main(String []args) {
        String url = "http://th.if.uj.edu.pl/";
        String test = "Institute of Theoretical Physics";

        System.out.println("Test strony: " + url);

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
                System.out.println("Status: " + response.statusCode());
                System.exit(1);
            }

            String type = response.headers()
                    .firstValue("Content-Type")
                    .orElse("");

            if (!type.contains("text/html")) {
                System.out.println("Typ: " + type);
                System.exit(2);
            }

            if (!response.body().contains(test)) {
                System.out.println("Nieprawidłowa zawartość strony");
                System.exit(3);
            }

            System.out.println("Status: " + response.statusCode());
            System.out.println("Typ: " + type);
            System.out.println("Strona działa prawidłowo!");
            System.exit(0);

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            System.exit(4);
        }
    }
}
