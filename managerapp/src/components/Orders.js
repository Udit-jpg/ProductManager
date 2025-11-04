import React, { useState, useEffect } from 'react';

const API_URL = 'http://localhost:8083/orders';

function Orders() {
  const [orders, setOrders] = useState([]);
  const [formData, setFormData] = useState({
    userId: '',
    productId: '',
    quantity: '',
    totalPrice: '',
    status: 'PENDING'
  });
  const [editing, setEditing] = useState(false);
  const [editId, setEditId] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      const response = await fetch(API_URL);
      const data = await response.json();
      setOrders(data);
    } catch (err) {
      setError('Failed to fetch orders');
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
          userId: parseInt(formData.userId),
          productId: parseInt(formData.productId),
          quantity: parseInt(formData.quantity),
          totalPrice: parseFloat(formData.totalPrice)
        }),
      });

      if (response.ok) {
        setSuccess(editing ? 'Order updated successfully!' : 'Order created successfully!');
        setFormData({ userId: '', productId: '', quantity: '', totalPrice: '', status: 'PENDING' });
        setEditing(false);
        setEditId(null);
        fetchOrders();
      } else {
        setError('Operation failed');
      }
    } catch (err) {
      setError('Failed to save order');
    }
  };

  const handleEdit = (order) => {
    setFormData({
      userId: order.userId.toString(),
      productId: order.productId.toString(),
      quantity: order.quantity.toString(),
      totalPrice: order.totalPrice.toString(),
      status: order.status
    });
    setEditing(true);
    setEditId(order.id);
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this order?')) {
      try {
        await fetch(`${API_URL}/${id}`, {
          method: 'DELETE',
        });
        setSuccess('Order deleted successfully!');
        fetchOrders();
      } catch (err) {
        setError('Failed to delete order');
      }
    }
  };

  const handleStatusUpdate = async (id, newStatus) => {
    try {
      const response = await fetch(`${API_URL}/${id}/status`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: newStatus }),
      });

      if (response.ok) {
        setSuccess('Order status updated successfully!');
        fetchOrders();
      } else {
        setError('Failed to update status');
      }
    } catch (err) {
      setError('Failed to update order status');
    }
  };

  const handleCancel = () => {
    setFormData({ userId: '', productId: '', quantity: '', totalPrice: '', status: 'PENDING' });
    setEditing(false);
    setEditId(null);
  };

  return (
    <div className="component-container">
      <h2>🛒 Order Management</h2>

      {error && <div className="error-message">{error}</div>}
      {success && <div className="success-message">{success}</div>}

      <div className="form-container">
        <h3>{editing ? 'Edit Order' : 'Create New Order'}</h3>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>User ID:</label>
            <input
              type="number"
              value={formData.userId}
              onChange={(e) => setFormData({ ...formData, userId: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Product ID:</label>
            <input
              type="number"
              value={formData.productId}
              onChange={(e) => setFormData({ ...formData, productId: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Quantity:</label>
            <input
              type="number"
              value={formData.quantity}
              onChange={(e) => setFormData({ ...formData, quantity: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Total Price ($):</label>
            <input
              type="number"
              step="0.01"
              value={formData.totalPrice}
              onChange={(e) => setFormData({ ...formData, totalPrice: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Status:</label>
            <select
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value })}
            >
              <option value="PENDING">Pending</option>
              <option value="CONFIRMED">Confirmed</option>
              <option value="SHIPPED">Shipped</option>
              <option value="DELIVERED">Delivered</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </div>
          <div className="action-buttons">
            <button type="submit" className="btn btn-primary">
              {editing ? 'Update Order' : 'Create Order'}
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
        <h3>All Orders ({orders.length})</h3>
        {orders.length === 0 ? (
          <div className="empty-state">No orders found. Create a new order to get started!</div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>User ID</th>
                <th>Product ID</th>
                <th>Quantity</th>
                <th>Total Price</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((order) => (
                <tr key={order.id}>
                  <td>{order.id}</td>
                  <td>{order.userId}</td>
                  <td>{order.productId}</td>
                  <td>{order.quantity}</td>
                  <td>${order.totalPrice.toFixed(2)}</td>
                  <td>
                    <span className={`badge ${
                      order.status === 'DELIVERED' ? 'badge-success' : 
                      order.status === 'SHIPPED' ? 'badge-info' : 
                      order.status === 'CONFIRMED' ? 'badge-primary' : 
                      order.status === 'CANCELLED' ? 'badge-danger' : 
                      'badge-warning'
                    }`}>
                      {order.status}
                    </span>
                  </td>
                  <td>
                    <div className="action-buttons">
                      <button
                        className="btn btn-warning"
                        onClick={() => handleEdit(order)}
                      >
                        Edit
                      </button>
                      {order.status === 'PENDING' && (
                        <button
                          className="btn btn-success"
                          onClick={() => handleStatusUpdate(order.id, 'CONFIRMED')}
                        >
                          Confirm
                        </button>
                      )}
                      <button
                        className="btn btn-danger"
                        onClick={() => handleDelete(order.id)}
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

export default Orders;
