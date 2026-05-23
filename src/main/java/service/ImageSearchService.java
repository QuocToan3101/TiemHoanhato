package service;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.FloatBuffer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.stream.Collectors;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

import javax.imageio.ImageIO;

import org.tensorflow.SavedModelBundle;
import org.tensorflow.Session;
import org.tensorflow.Tensor;

/**
 * ImageSearchService
 * - Loads embedding SavedModel at startup
 * - Provides method to compute embedding from image and search a precomputed index
 *
 * Note: you should generate an embeddings JSON or binary file for the product catalog
 * and place it under `src/main/resources/models/<model>/embeddings.json`.
 */
public class ImageSearchService {

    private SavedModelBundle embeddingModel;
    private Session session;

    // simple in-memory index: id -> vector
    private final Map<Integer, float[]> index = new HashMap<>();

    public ImageSearchService(String modelPath) {
        init(modelPath);
    }

    private void init(String modelPath) {
        try {
            // modelPath can be like "classpath:models/flower_model/saved_embedding"
            String p = modelPath;
            if (p.startsWith("classpath:")) {
                p = p.substring("classpath:".length());
                // resource extraction not implemented here; assume file path for now
            }

            Path modelDir = Paths.get(p);
            if (!Files.exists(modelDir)) {
                System.err.println("Embedding model not found: " + modelDir);
                return;
            }

            System.out.println("Loading embedding model from " + modelDir);
            embeddingModel = SavedModelBundle.load(modelDir.toString(), "serve");
            session = embeddingModel.session();

            // try loading embeddings from resources
            try (InputStream is = getClass().getClassLoader().getResourceAsStream("models/flower_model/embeddings.json")) {
                if (is != null) {
                    loadIndexFromJson(is);
                } else {
                    System.out.println("No embeddings.json found in classpath; index remains empty");
                }
            }

        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

    private void loadIndexFromJson(InputStream is) throws IOException {
        try (BufferedReader r = new BufferedReader(new InputStreamReader(is))) {
            String json = r.lines().collect(Collectors.joining());
            Gson gson = new Gson();
            JsonObject obj = gson.fromJson(json, JsonObject.class);
            for (Map.Entry<String, JsonElement> e : obj.entrySet()) {
                String idStr = e.getKey();
                JsonArray arr = e.getValue().getAsJsonArray();
                float[] vec = new float[arr.size()];
                for (int i = 0; i < arr.size(); i++) vec[i] = arr.get(i).getAsFloat();
                index.put(Integer.parseInt(idStr), vec);
            }
        }
    }

    public float[] extractEmbedding(BufferedImage img) {
        // Preprocess image to float array matching model expectations: resize to ai.img.size, normalize
        // For brevity this is left as a TODO. Implement using Thumbnailator or ImageIO to resize,
        // convert to float[][][] and feed into Tensor.

        // Example invocation (pseudocode):
        // Tensor input = Tensor.create(new long[]{1, h, w, 3}, FloatBuffer.wrap(flatFloatArray));
        // Tensor out = session.runner().feed("serving_default_input_1", input).fetch("StatefulPartitionedCall").run().get(0);

        throw new UnsupportedOperationException("extractEmbedding not implemented yet");
    }

    public List<SearchResult> search(float[] query, int topK) {
        PriorityQueue<SearchResult> pq = new PriorityQueue<>(Comparator.comparingDouble(r -> r.score));
        for (Map.Entry<Integer, float[]> e : index.entrySet()) {
            float[] v = e.getValue();
            double score = cosineSimilarity(query, v);
            if (pq.size() < topK) pq.add(new SearchResult(e.getKey(), score));
            else if (score > pq.peek().score) {
                pq.poll();
                pq.add(new SearchResult(e.getKey(), score));
            }
        }
        List<SearchResult> out = new ArrayList<>();
        while (!pq.isEmpty()) out.add(pq.poll());
        // reverse
        out.sort(Comparator.comparingDouble((SearchResult r) -> r.score).reversed());
        return out;
    }

    private double cosineSimilarity(float[] a, float[] b) {
        double dot = 0, na = 0, nb = 0;
        for (int i = 0; i < a.length; i++) {
            dot += a[i] * b[i];
            na += a[i] * a[i];
            nb += b[i] * b[i];
        }
        if (na == 0 || nb == 0) return 0;
        return dot / (Math.sqrt(na) * Math.sqrt(nb));
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
