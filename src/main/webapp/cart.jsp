<%@ page import="connection.*"%>
<%@ page import="model.*"%>
<%@ page import="dao.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
DecimalFormat dcf = new DecimalFormat("#.##");
request.setAttribute("dcf", dcf);
User auth = (User) request.getSession().getAttribute("auth");
if (auth != null) {
    request.setAttribute("person", auth);
}
ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
List<Cart> cartProduct = null;
if (cart_list != null) {
    ProductDao pDao = new ProductDao(DbCon.getConnection());
    cartProduct = pDao.getCartProducts(cart_list);
    double total = pDao.getTotalCartPrice(cart_list);
    request.setAttribute("total", total);
    request.setAttribute("cart_list", cart_list);
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Cart</title>
<style type="text/css">
.table tbody td {
    vertical-align: middle;
}

.btn-incre, .btn-decre {
    box-shadow: none;
    font-size: 20px;
}

.quantity-box {
    width: 50px;
    text-align: center;
    font-size: 18px;
}

.total-price {
    font-size: 24px;
    font-weight: bold;
    color: #333;
}

.container {
    max-width: 1200px;
}

.btn-primary {
    margin-left: 15px;
}
</style>

<!-- Include Bootstrap CSS -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<!-- Include FontAwesome for icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

</head>
<body>

    <!-- Navbar -->
    <%@include file="includes/navbar.jsp"%>

    <div class="container my-5">
        <div class="d-flex justify-content-between py-3">
            <h3 class="total-price">Total Price: $ ${(total > 0) ? dcf.format(total) : 0}</h3>
            <a class="btn btn-primary" href="cart-check-out">Check Out</a>
        </div>
        
        <table class="table table-light table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th scope="col">Name</th>
                    <th scope="col">Category</th>
                    <th scope="col">Price</th>
                    <th scope="col">Quantity</th>
                    <th scope="col">Buy Now</th>
                    <th scope="col">Cancel</th>
                </tr>
            </thead>
            <tbody>
                <%
                if (cart_list != null) {
                    for (Cart c : cartProduct) {
                %>
                <tr>
                    <td><%= c.getName() %></td>
                    <td><%= c.getCategory() %></td>
                    <td>$<%= dcf.format(c.getPrice()) %></td>
                    <td>
                        <div class="d-flex align-items-center">
                            <a class="btn btn-outline-secondary btn-sm btn-incre"
                                href="quantity-inc-dec?action=inc&id=<%= c.getId() %>">
                                <i class="fas fa-plus"></i>
                            </a>
                            <input type="text" class="form-control quantity-box mx-2" name="quantity"
                                   value="<%= c.getQuantity() %>" readonly>
                            <a class="btn btn-outline-secondary btn-sm btn-decre"
                                href="quantity-inc-dec?action=dec&id=<%= c.getId() %>">
                                <i class="fas fa-minus"></i>
                            </a>
                        </div>
                    </td>
                    <td>
                        <form action="order-now" method="post" class="form-inline">
                            <input type="hidden" name="id" value="<%= c.getId() %>">
                            <button type="submit" class="btn btn-primary btn-sm">Buy</button>
                        </form>
                    </td>
                    <td>
                        <a href="remove-from-cart?id=<%= c.getId() %>" class="btn btn-danger btn-sm">Remove</a>
                    </td>
                </tr>
                <%
                    }
                }
                %>
            </tbody>
        </table>
    </div>

    <%@include file="includes/footer.jsp"%>

    <!-- Include Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
