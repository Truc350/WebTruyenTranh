package controller;

import dao.ComicDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Comic;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private ComicDAO comicDAO;

    @Override
    public void init() {
        comicDAO = new ComicDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<Comic> comics = comicDAO.search(keyword);

        request.setAttribute("keyword", keyword);
        request.setAttribute("comics", comics);

        request.getRequestDispatcher("/fontend/public/searchResult.jsp")
                .forward(request, response);
    }
}

