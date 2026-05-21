package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebListener
public class MlServiceBootstrapListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(MlServiceBootstrapListener.class);

    private Process mlProcess;
    private ExecutorService logReader;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        AppConfig config = AppConfig.getInstance();

        if (!config.isMlImageSearchEnabled()) {
            logger.info("ML image search disabled, skip autostart");
            return;
        }

        if (!config.isMlImageSearchAutoStartEnabled()) {
            logger.info("ML image search autostart disabled, skip bootstrap");
            return;
        }

        String baseUrl = config.getMlImageSearchBaseUrl();
        if (isHealthy(baseUrl)) {
            logger.info("ML service already healthy at {}", baseUrl);
            return;
        }

        Path workingDir = resolveWorkingDir(config.getMlImageSearchWorkingDir(), sce.getServletContext());
        if (workingDir == null || !Files.isDirectory(workingDir)) {
            logger.warn("ML working directory not found: {}", config.getMlImageSearchWorkingDir());
            return;
        }

        Path appFile = workingDir.resolve("app.py");
        if (!Files.exists(appFile)) {
            logger.warn("ML app.py not found in {}", workingDir.toAbsolutePath());
            return;
        }

        String pythonCmd = config.getMlImageSearchPythonCommand();

        try {
            ProcessBuilder processBuilder = new ProcessBuilder(pythonCmd, "app.py");
            processBuilder.directory(workingDir.toFile());
            processBuilder.redirectErrorStream(true);

            mlProcess = processBuilder.start();
            logger.info("Started ML service process in {}", workingDir.toAbsolutePath());

            logReader = Executors.newSingleThreadExecutor(r -> {
                Thread t = new Thread(r, "ml-service-log-reader");
                t.setDaemon(true);
                return t;
            });

            logReader.submit(() -> {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(mlProcess.getInputStream(), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        logger.info("[ml-service] {}", line);
                    }
                } catch (IOException ex) {
                    logger.debug("ML log reader stopped: {}", ex.getMessage());
                }
            });

            int timeoutMs = Math.max(5000, config.getMlImageSearchStartupTimeoutMs());
            boolean ready = waitForHealthy(baseUrl, timeoutMs);
            if (ready) {
                logger.info("ML service is ready at {}", baseUrl);
            } else {
                logger.warn("ML service not healthy after {} ms", timeoutMs);
            }
        } catch (IOException ex) {
            logger.error("Failed to autostart ML service", ex);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (logReader != null) {
            logReader.shutdownNow();
            logReader = null;
        }

        if (mlProcess != null && mlProcess.isAlive()) {
            logger.info("Stopping ML service process");
            mlProcess.destroy();
            try {
                if (!mlProcess.waitFor(3, java.util.concurrent.TimeUnit.SECONDS)) {
                    mlProcess.destroyForcibly();
                }
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
                mlProcess.destroyForcibly();
            }
        }
        mlProcess = null;
    }

    private Path resolveWorkingDir(String configuredDir, ServletContext servletContext) {
        if (configuredDir == null || configuredDir.isBlank()) {
            return null;
        }

        Path configuredPath = Paths.get(configuredDir);
        if (configuredPath.isAbsolute() && Files.exists(configuredPath)) {
            return configuredPath;
        }

        Path fromUserDir = Paths.get(System.getProperty("user.dir", ".")).resolve(configuredDir).normalize();
        if (Files.exists(fromUserDir)) {
            return fromUserDir;
        }

        String webRoot = servletContext.getRealPath("/");
        if (webRoot != null) {
            Path fromWebRoot = Paths.get(webRoot).resolve(configuredDir).normalize();
            if (Files.exists(fromWebRoot)) {
                return fromWebRoot;
            }
        }

        return null;
    }

    private boolean waitForHealthy(String baseUrl, int timeoutMs) {
        Instant start = Instant.now();
        while (Duration.between(start, Instant.now()).toMillis() < timeoutMs) {
            if (isHealthy(baseUrl)) {
                return true;
            }
            try {
                Thread.sleep(600);
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
                return false;
            }
        }
        return false;
    }

    private boolean isHealthy(String baseUrl) {
        if (baseUrl == null || baseUrl.isBlank()) {
            return false;
        }

        HttpURLConnection connection = null;
        try {
            URL url = new URL(joinUrl(baseUrl, "/health"));
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(1000);
            connection.setReadTimeout(1500);
            connection.setRequestMethod("GET");

            int code = connection.getResponseCode();
            return code >= 200 && code < 300;
        } catch (Exception ex) {
            return false;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private String joinUrl(String baseUrl, String path) {
        if (baseUrl.endsWith("/") && path.startsWith("/")) {
            return baseUrl.substring(0, baseUrl.length() - 1) + path;
        }
        if (!baseUrl.endsWith("/") && !path.startsWith("/")) {
            return baseUrl + "/" + path;
        }
        return baseUrl + path;
    }
}
