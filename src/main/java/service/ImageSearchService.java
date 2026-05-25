package service;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import util.AppConfig;

/**
 * ImageSearchService (remote)
 * - Replaces in-process TF model with a lightweight HTTP client that calls an external
 *   image-search / embedding service. This keeps the WAR small and avoids native TF libs.
 */
public class ImageSearchService {

    private final OkHttpClient http = new OkHttpClient();
    private final Gson gson = new Gson();
    private final String baseUrl;
    private String initializationError;

    public ImageSearchService(String ignored) {
        AppConfig cfg = AppConfig.getInstance();
        this.baseUrl = cfg.getMlImageSearchBaseUrl();
        init();
    }

    private void init() {
        if (baseUrl == null || baseUrl.isBlank()) {
            initializationError = "ML service base URL not configured";
            return;
        }
        // Optional: perform a quick health check
        try {
            Request req = new Request.Builder().url(baseUrl.endsWith("/") ? baseUrl + "health" : baseUrl + "/health").get().build();
            try (Response r = http.newCall(req).execute()) {
                if (!r.isSuccessful()) {
                    initializationError = "ML service not healthy: " + r.code();
                }
            }
        } catch (Exception e) {
            initializationError = "ML service health check failed: " + e.getMessage();
        }
    }

    public String getInitializationError() {
        return initializationError;
    }

    public boolean isReady() {
        return initializationError == null;
    }

    /**
     * Request an embedding for the provided image from the external service.
     * Endpoint expected: POST {baseUrl}/embedding (multipart, field 'image') -> returns JSON array of floats
     */
    public float[] extractEmbedding(BufferedImage img) throws IOException {
        if (!isReady()) throw new IllegalStateException("ML service not ready: " + initializationError);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(img, "jpg", baos);
        byte[] bytes = baos.toByteArray();

        RequestBody fileBody = RequestBody.create(bytes, MediaType.parse("image/jpeg"));
        MultipartBody requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM)
                .addFormDataPart("image", "upload.jpg", fileBody)
                .build();

        Request req = new Request.Builder().url(baseUrl.endsWith("/") ? baseUrl + "embedding" : baseUrl + "/embedding")
                .post(requestBody).build();

        try (Response resp = http.newCall(req).execute()) {
            if (!resp.isSuccessful()) throw new IOException("Embedding request failed: " + resp.code());
            String body = resp.body().string();
            JsonArray arr = gson.fromJson(body, JsonArray.class);
            float[] out = new float[arr.size()];
            for (int i = 0; i < arr.size(); i++) out[i] = arr.get(i).getAsFloat();
            return out;
        }
    }

    /**
     * Search by a precomputed query vector using the external service.
     * Endpoint expected: POST {baseUrl}/search with JSON {"vector": [...], "top_k": N}
     * Returns list of {id,score}.
     */
    public List<SearchResult> search(float[] query, int topK) throws IOException {
        if (!isReady()) throw new IllegalStateException("ML service not ready: " + initializationError);

        JsonObject payload = new JsonObject();
        JsonArray arr = new JsonArray();
        for (float v : query) arr.add(v);
        payload.add("vector", arr);
        payload.addProperty("top_k", topK);

        RequestBody body = RequestBody.create(gson.toJson(payload), MediaType.parse("application/json; charset=utf-8"));
        Request req = new Request.Builder().url(baseUrl.endsWith("/") ? baseUrl + "search" : baseUrl + "/search").post(body).build();

        try (Response resp = http.newCall(req).execute()) {
            if (!resp.isSuccessful()) throw new IOException("Search request failed: " + resp.code());
            String s = resp.body().string();
            JsonArray results = gson.fromJson(s, JsonArray.class);
            List<SearchResult> out = new ArrayList<>();
            for (JsonElement e : results) {
                JsonObject o = e.getAsJsonObject();
                int id = o.get("id").getAsInt();
                double score = o.get("score").getAsDouble();
                out.add(new SearchResult(id, score));
            }
            return out;
        }
    }

    public static class SearchResult {
        public final int id;
        public final double score;

        public SearchResult(int id, double score) {
            this.id = id;
            this.score = score;
        }
    }
}
