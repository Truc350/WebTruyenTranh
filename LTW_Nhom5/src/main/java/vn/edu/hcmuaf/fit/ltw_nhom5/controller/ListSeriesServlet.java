package vn.edu.hcmuaf.fit.ltw_nhom5.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.ltw_nhom5.dao.SeriesDAO;
import vn.edu.hcmuaf.fit.ltw_nhom5.model.Series;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@WebServlet("/admin/series/list")
public class ListSeriesServlet extends HttpServlet {

    private SeriesDAO seriesDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        System.out.println(" Initializing ListSeriesServlet...");
        try {
            seriesDAO = new SeriesDAO();

            // TẠO GSON VỚI CUSTOM SERIALIZER CHO LocalDateTime
            gson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class,
                            (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                                    context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
                    .create();

            System.out.println(" ListSeriesServlet initialized successfully!");
        } catch (Exception e) {
            System.err.println(" Error initializing ListSeriesServlet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ListSeriesServlet doGet called");

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> result = new HashMap<>();

        try {
            System.out.println(" Fetching series from DAO...");
            List<Series> seriesList = seriesDAO.getAllSeries();
            System.out.println("Series fetched: " + (seriesList != null ? seriesList.size() : "null"));

            result.put("success", true);
            result.put("series", seriesList);

        } catch (Exception e) {
            System.err.println("Error loading series: " + e.getMessage());
            e.printStackTrace();

            result.put("success", false);
            result.put("message", "Lỗi server: " + e.getMessage());
        }

        String json = gson.toJson(result);
        System.out.println("Sending response: " + json.substring(0, Math.min(100, json.length())) + "...");
        response.getWriter().write(json);
    }
}