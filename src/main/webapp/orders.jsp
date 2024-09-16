<%@page import="java.text.DecimalFormat"%>
<%@page import="dao.*"%>
<%@page import="connection.DbCon"%>
<%@page import="model.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    DecimalFormat dcf = new DecimalFormat("#.##");
    request.setAttribute("dcf", dcf);
    User auth = (User) request.getSession().getAttribute("auth");
    List<Order> orders = null;
    if (auth != null) {
        request.setAttribute("person", auth);
        OrderDao orderDao = new OrderDao(DbCon.getConnection());
        orders = orderDao.userOrders(auth.getId());
    } else {
        response.sendRedirect("login.jsp");
    }
    ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
    if (cart_list != null) {
        request.setAttribute("cart_list", cart_list);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="/includes/head.jsp"%>
    <title>Orders</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <%@include file="/includes/navbar.jsp"%>

    <div class="container my-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4>All Orders</h4>
            </div>
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col">Date</th>
                            <th scope="col">Name</th>
                            <th scope="col">Category</th>
                            <th scope="col">Quantity</th>
                            <th scope="col">Price</th>
                            <th scope="col">Cancel</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (orders != null && !orders.isEmpty()) {
                            for (Order o : orders) {
                        %>
                        <tr>
                            <td><%= o.getDate() %></td>
                            <td><%= o.getName() %></td>
                            <td><%= o.getCategory() %></td>
                            <td><%= o.getQunatity() %></td>
                            <td>$<%= dcf.format(o.getPrice()) %></td>
                            <td>
                                <a class="btn btn-sm btn-danger" href="cancel-order?id=<%= o.getOrderId() %>">Cancel Order</a>
                            </td>
                        </tr>
                        <%
                            }
                        } else {
                        %>
                        <tr>
                            <td colspan="6" class="text-center">No Orders Found</td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%@include file="/includes/footer.jsp"%>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
