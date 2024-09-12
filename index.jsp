<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Management</title>
</head>
<body>
    <h1>Product List</h1>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Description</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody id="productTableBody">
            <!-- Products will be dynamically inserted here using JavaScript -->
        </tbody>
    </table>

    <h2>Add/Update Product</h2>
    <form id="productForm">
        <label for="productId">ID:</label>
        <input type="text" id="productId" name="productId" readonly><br><br>

        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br><br>

        <label for="description">Description:</label>
        <input type="text" id="description" name="description" required><br><br>

        <label for="price">Price:</label>
        <input type="number" id="price" name="price" step="0.01" required><br><br>

        <button type="submit">Submit</button>
    </form>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Fetch all products and populate the table
            fetchProducts();

            // Handle form submission for adding/updating product
            document.getElementById('productForm').addEventListener('submit', function(event) {
                event.preventDefault();
                var product = {
                    id: document.getElementById('productId').value,
                    name: document.getElementById('name').value,
                    description: document.getElementById('description').value,
                    price: document.getElementById('price').value
                };

                if (product.id) {
                    // Update product
                    fetch(/products/${product.id}, {
                        method: 'PUT',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('token')
                        },
                        body: JSON.stringify(product)
                    }).then(response => fetchProducts());
                } else {
                    // Add new product
                    fetch('/products', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + localStorage.getItem('token')
                        },
                        body: JSON.stringify(product)
                    }).then(response => fetchProducts());
                }
            });
        });

        function fetchProducts() {
            fetch('/products', {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('token')
                }
            })
            .then(response => response.json())
            .then(products => {
                var productTableBody = document.getElementById('productTableBody');
                productTableBody.innerHTML = '';
                products.forEach(product => {
                    var row = `<tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.description}</td>
                        <td>${product.price}</td>
                        <td>
                            <button onclick="editProduct(${product.id})">Edit</button>
                            <button onclick="deleteProduct(${product.id})">Delete</button>
                        </td>
                    </tr>`;
                    productTableBody.innerHTML += row;
                });
            });
        }

        function editProduct(id) {
            fetch(/products/${id}, {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('token')
                }
            })
            .then(response => response.json())
            .then(product => {
                document.getElementById('productId').value = product.id;
                document.getElementById('name').value = product.name;
                document.getElementById('description').value = product.description;
                document.getElementById('price').value = product.price;
            });
        }

        function deleteProduct(id) {
            fetch(/products/${id}, {
                method: 'DELETE',
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('token')
                }
            }).then(response => fetchProducts());
        }
    </script>
</body>
</html>