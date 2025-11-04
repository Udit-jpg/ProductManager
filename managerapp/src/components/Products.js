import React, { useState, useEffect } from 'react';

const API_URL = 'http://localhost:8082/products';

function Products() {
  const [products, setProducts] = useState([]);
  const [formData, setFormData] = useState({
    name: '',
    category: '',
    price: '',
    stock: ''
  });
  const [editing, setEditing] = useState(false);
  const [editId, setEditId] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const response = await fetch(API_URL);
      const data = await response.json();
      setProducts(data);
    } catch (err) {
      setError('Failed to fetch products');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    try {
      const url = editing ? `${API_URL}/${editId}` : API_URL;
      const method = editing ? 'PUT' : 'POST';

      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...formData,
          price: parseFloat(formData.price),
          stock: parseInt(formData.stock)
        }),
      });

      if (response.ok) {
        setSuccess(editing ? 'Product updated successfully!' : 'Product created successfully!');
        setFormData({ name: '', category: '', price: '', stock: '' });
        setEditing(false);
        setEditId(null);
        fetchProducts();
      } else {
        setError('Operation failed');
      }
    } catch (err) {
      setError('Failed to save product');
    }
  };

  const handleEdit = (product) => {
    setFormData({
      name: product.name,
      category: product.category,
      price: product.price.toString(),
      stock: product.stock.toString()
    });
    setEditing(true);
    setEditId(product.id);
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this product?')) {
      try {
        await fetch(`${API_URL}/${id}`, {
          method: 'DELETE',
        });
        setSuccess('Product deleted successfully!');
        fetchProducts();
      } catch (err) {
        setError('Failed to delete product');
      }
    }
  };

  const handleCancel = () => {
    setFormData({ name: '', category: '', price: '', stock: '' });
    setEditing(false);
    setEditId(null);
  };

  return (
    <div className="component-container">
      <h2>📦 Product Management</h2>

      {error && <div className="error-message">{error}</div>}
      {success && <div className="success-message">{success}</div>}

      <div className="form-container">
        <h3>{editing ? 'Edit Product' : 'Add New Product'}</h3>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Product Name:</label>
            <input
              type="text"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Category:</label>
            <select
              value={formData.category}
              onChange={(e) => setFormData({ ...formData, category: e.target.value })}
              required
            >
              <option value="">Select Category</option>
              <option value="Electronics">Electronics</option>
              <option value="Clothing">Clothing</option>
              <option value="Books">Books</option>
              <option value="Home">Home</option>
              <option value="Sports">Sports</option>
              <option value="Toys">Toys</option>
              <option value="Other">Other</option>
            </select>
          </div>
          <div className="form-group">
            <label>Price ($):</label>
            <input
              type="number"
              step="0.01"
              value={formData.price}
              onChange={(e) => setFormData({ ...formData, price: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Stock:</label>
            <input
              type="number"
              value={formData.stock}
              onChange={(e) => setFormData({ ...formData, stock: e.target.value })}
              required
            />
          </div>
          <div className="action-buttons">
            <button type="submit" className="btn btn-primary">
              {editing ? 'Update Product' : 'Add Product'}
            </button>
            {editing && (
              <button type="button" className="btn btn-warning" onClick={handleCancel}>
                Cancel
              </button>
            )}
          </div>
        </form>
      </div>

      <div className="table-container">
        <h3>All Products ({products.length})</h3>
        {products.length === 0 ? (
          <div className="empty-state">No products found. Add a new product to get started!</div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {products.map((product) => (
                <tr key={product.id}>
                  <td>{product.id}</td>
                  <td>{product.name}</td>
                  <td>
                    <span className="badge badge-info">{product.category}</span>
                  </td>
                  <td>${product.price.toFixed(2)}</td>
                  <td>
                    <span className={`badge ${
                      product.stock > 50 ? 'badge-success' : 
                      product.stock > 0 ? 'badge-warning' : 
                      'badge-danger'
                    }`}>
                      {product.stock}
                    </span>
                  </td>
                  <td>
                    <div className="action-buttons">
                      <button
                        className="btn btn-warning"
                        onClick={() => handleEdit(product)}
                      >
                        Edit
                      </button>
                      <button
                        className="btn btn-danger"
                        onClick={() => handleDelete(product.id)}
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

export default Products;
