package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

            @WebServlet(name = "ProxyServlet", value = "/api/provinces/*")
            public class ProxyServlet extends HttpServlet {

                private static final String API_BASE = "https://provinces.open-api.vn/api/v2";

                @Override
                protected void doGet(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.setHeader("Access-Control-Allow-Origin", "*");

                    String pathInfo = request.getPathInfo();
                    String queryString = request.getQueryString();

                    String targetUrl;

                    // Xử lý các endpoint
                    if (pathInfo == null || pathInfo.equals("/") || pathInfo.isEmpty()) {
                        // GET /api/provinces -> GET /p/
                        targetUrl = API_BASE + "/p/";

                    } else if (pathInfo.startsWith("/p/")) {
                        // GET /api/provinces/p/79 -> GET /p/79
                        targetUrl = API_BASE + pathInfo;
                        if (queryString != null) {
                            targetUrl += "?" + queryString;
                        }

                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("{\"error\": \"Unknown endpoint: " + pathInfo + "\"}");
                        return;
                    }

                    System.out.println("🔄 Proxy request to: " + targetUrl);

                    HttpURLConnection conn = null;
                    BufferedReader in = null;

                    try {
                        URL url = new URL(targetUrl);
                        conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("GET");
                        conn.setConnectTimeout(15000);
            conn.setReadTimeout(15000);
            conn.setRequestProperty("User-Agent", "Mozilla/5.0");
            conn.setRequestProperty("Accept", "application/json");

            int responseCode = conn.getResponseCode();
            System.out.println("📥 Response code: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) {
                in = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "UTF-8")
                );
                StringBuilder content = new StringBuilder();
                String inputLine;

                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }

                String jsonResponse = content.toString();
                System.out.println("✅ Response length: " + jsonResponse.length());

                response.getWriter().write(jsonResponse);

            } else {
                System.err.println("❌ API error: " + responseCode);
                response.setStatus(responseCode);
                response.getWriter().write("{\"error\": \"API returned code " + responseCode + "\"}");
            }

        } catch (Exception e) {
            System.err.println("💥 Exception: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");

        } finally {
            if (in != null) {
                try { in.close(); } catch (IOException e) { /* ignore */ }
            }
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}