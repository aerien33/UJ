import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.Map;
import java.util.TreeMap;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DiscogsApp {
    private static final TreeMap<String, ArrayList<String>> groups = new TreeMap<>();

    private static void checkResponse(HttpResponse<String> response, StringBuilder url) {
        if (response.statusCode() != 200) {
            System.out.println("Request: " + url);
            System.out.println("Status: " + response.statusCode());
            System.exit(3);
        }

        String type = response.headers()
                .firstValue("Content-Type")
                .orElse("");

        if (!type.contains("application/json")) {
            System.out.println("Request: " + url);
            System.out.println("Type: " + type);
            System.exit(4);
        }
    }

    private static HttpResponse<String> sendRequest(int id, HttpClient client) throws IOException, InterruptedException {
        StringBuilder url = new StringBuilder("https://api.discogs.com/artists/");

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url.append(id).toString()))
                .header("User-Agent", "discogs-app/1.0 (agnieszka.wawer@student.uj.edu.pl)")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        int reqLimit = Integer.parseInt(response.headers()
                .firstValue("X-Discogs-Ratelimit-Remaining")
                .orElse("-1"));

        if (reqLimit == -1) {
            System.out.println("Request: " + url);
            System.out.println("Error: Cannot access remaining requests");
            System.exit(2);
        } else if (reqLimit == 0) {
            Thread.sleep(60000); // 1 minuta
            response = client.send(request, HttpResponse.BodyHandlers.ofString());
        }

        checkResponse(response, url);

        return response;
    }

    private static JsonNode getRoot(HttpResponse<String> response) throws IOException, InterruptedException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readTree(response.body());
    }

    private static boolean isMember(int artistId, HttpResponse<String> response) throws IOException, InterruptedException {
        JsonNode root = getRoot(response);
        JsonNode members = root.get("members");
        for (JsonNode member : members) {
            if (member.get("id").asInt() == artistId) {
                return true;
            }
        }

        return false;
    }

    private static void printResult() {
        for (Map.Entry<String, ArrayList<String>> entry : groups.entrySet()) {
            String groupName = entry.getKey();
            ArrayList<String> members = entry.getValue();

            if (members.size() > 1) {
                System.out.println(groupName + ":");
                for (String member : members) {
                    System.out.println("\t" + member);
                }
            }
        }
    }

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Error: min. 2 arguments required");
            System.exit(1);
        }

        try (HttpClient client = HttpClient.newHttpClient()) {
            for (String arg : args) {
                int artistId = Integer.parseInt(arg);
                HttpResponse<String> response = sendRequest(artistId, client);
                JsonNode root = getRoot(response);
                String artist = root.get("name").asText();

                for (JsonNode group : root.get("groups")) {
                    int groupId = group.get("id").asInt();
                    String groupName = group.get("name").asText();

                    if (!isMember(artistId, sendRequest(groupId, client))) {
                        System.out.println("Error: " + artist + " is not a member of " + groupName);
                        System.exit(5);
                    }

                    if (!groups.containsKey(groupName))
                        groups.put(groupName, new ArrayList<>());
                    groups.get(groupName).add(artist);
                }
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            System.exit(6);
        }

        printResult();
    }
}
