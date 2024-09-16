package Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import connection.DbCon;
import dao.OrderDao;


public class OrderNowServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    response.setContentType("text/html;charset=UTF-8");
	    try (PrintWriter out = response.getWriter()) {
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	        Date date = new Date(System.currentTimeMillis());

	        User auth = (User) request.getSession().getAttribute("auth");

	        if (auth != null) {
	            String productId = request.getParameter("id");
	            String quantityParam = request.getParameter("quantity");
	            int productQuantity = (quantityParam != null && !quantityParam.isEmpty()) ? Integer.parseInt(quantityParam) : 1;

	            Order orderModel = new Order();
	            orderModel.setId(Integer.parseInt(productId));
	            orderModel.setUid(auth.getId());
	            orderModel.setQunatity(productQuantity);
	            orderModel.setDate(formatter.format(date));

	            OrderDao orderDao = new OrderDao(DbCon.getConnection());
	            boolean result = orderDao.insertOrder(orderModel);
	            if (result) {
	                ArrayList<Cart> cart_list = (ArrayList<Cart>) request.getSession().getAttribute("cart-list");
	                if (cart_list != null) {
	                    Iterator<Cart> iterator = cart_list.iterator();
	                    while (iterator.hasNext()) {
	                        Cart c = iterator.next();
	                        if (c.getId() == Integer.parseInt(productId)) {
	                            iterator.remove();  
	                            break;
	                        }
	                    }
	                }
	                response.sendRedirect("orders.jsp");
	            } else {
	                out.println("order failed");
	            }
	        } else {
	            response.sendRedirect("login.jsp");
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
