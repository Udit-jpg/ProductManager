import React, { useState, useEffect } from 'react';

const API_URL = 'http://localhost:8084/payments';

function Payments() {
  const [payments, setPayments] = useState([]);
  const [formData, setFormData] = useState({
    orderId: '',
    amount: '',
    paymentMode: 'CREDIT_CARD',
    paymentStatus: 'PENDING'
  });
  const [editing, setEditing] = useState(false);
  const [editId, setEditId] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    fetchPayments();
  }, []);

  const fetchPayments = async () => {
    try {
      const response = await fetch(API_URL);
      const data = await response.json();
      setPayments(data);
    } catch (err) {
      setError('Failed to fetch payments');
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
          orderId: parseInt(formData.orderId),
          amount: parseFloat(formData.amount)
        }),
      });

      if (response.ok) {
        setSuccess(editing ? 'Payment updated successfully!' : 'Payment created successfully!');
        setFormData({ orderId: '', amount: '', paymentMode: 'CREDIT_CARD', paymentStatus: 'PENDING' });
        setEditing(false);
        setEditId(null);
        fetchPayments();
      } else {
        setError('Operation failed');
      }
    } catch (err) {
      setError('Failed to save payment');
    }
  };

  const handleEdit = (payment) => {
    setFormData({
      orderId: payment.orderId.toString(),
      amount: payment.amount.toString(),
      paymentMode: payment.paymentMode,
      paymentStatus: payment.paymentStatus
    });
    setEditing(true);
    setEditId(payment.id);
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this payment?')) {
      try {
        await fetch(`${API_URL}/${id}`, {
          method: 'DELETE',
        });
        setSuccess('Payment deleted successfully!');
        fetchPayments();
      } catch (err) {
        setError('Failed to delete payment');
      }
    }
  };

  const handleProcessPayment = async (id) => {
    try {
      const response = await fetch(`${API_URL}/${id}/process`, {
        method: 'POST',
      });

      if (response.ok) {
        setSuccess('Payment processed successfully!');
        fetchPayments();
      } else {
        setError('Failed to process payment');
      }
    } catch (err) {
      setError('Failed to process payment');
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
        setSuccess('Payment status updated successfully!');
        fetchPayments();
      } else {
        setError('Failed to update status');
      }
    } catch (err) {
      setError('Failed to update payment status');
    }
  };

  const handleCancel = () => {
    setFormData({ orderId: '', amount: '', paymentMode: 'CREDIT_CARD', paymentStatus: 'PENDING' });
    setEditing(false);
    setEditId(null);
  };

  return (
    <div className="component-container">
      <h2>💳 Payment Management</h2>

      {error && <div className="error-message">{error}</div>}
      {success && <div className="success-message">{success}</div>}

      <div className="form-container">
        <h3>{editing ? 'Edit Payment' : 'Create New Payment'}</h3>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Order ID:</label>
            <input
              type="number"
              value={formData.orderId}
              onChange={(e) => setFormData({ ...formData, orderId: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Amount ($):</label>
            <input
              type="number"
              step="0.01"
              value={formData.amount}
              onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Payment Mode:</label>
            <select
              value={formData.paymentMode}
              onChange={(e) => setFormData({ ...formData, paymentMode: e.target.value })}
            >
              <option value="CREDIT_CARD">Credit Card</option>
              <option value="DEBIT_CARD">Debit Card</option>
              <option value="UPI">UPI</option>
              <option value="NET_BANKING">Net Banking</option>
              <option value="CASH">Cash</option>
            </select>
          </div>
          <div className="form-group">
            <label>Payment Status:</label>
            <select
              value={formData.paymentStatus}
              onChange={(e) => setFormData({ ...formData, paymentStatus: e.target.value })}
            >
              <option value="PENDING">Pending</option>
              <option value="SUCCESS">Success</option>
              <option value="FAILED">Failed</option>
              <option value="REFUNDED">Refunded</option>
            </select>
          </div>
          <div className="action-buttons">
            <button type="submit" className="btn btn-primary">
              {editing ? 'Update Payment' : 'Create Payment'}
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
        <h3>All Payments ({payments.length})</h3>
        {payments.length === 0 ? (
          <div className="empty-state">No payments found. Create a new payment to get started!</div>
        ) : (
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Order ID</th>
                <th>Amount</th>
                <th>Payment Mode</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {payments.map((payment) => (
                <tr key={payment.id}>
                  <td>{payment.id}</td>
                  <td>{payment.orderId}</td>
                  <td>${payment.amount.toFixed(2)}</td>
                  <td>
                    <span className="badge badge-info">{payment.paymentMode.replace('_', ' ')}</span>
                  </td>
                  <td>
                    <span className={`badge ${
                      payment.paymentStatus === 'SUCCESS' ? 'badge-success' : 
                      payment.paymentStatus === 'FAILED' ? 'badge-danger' : 
                      payment.paymentStatus === 'REFUNDED' ? 'badge-warning' : 
                      'badge-primary'
                    }`}>
                      {payment.paymentStatus}
                    </span>
                  </td>
                  <td>
                    <div className="action-buttons">
                      <button
                        className="btn btn-warning"
                        onClick={() => handleEdit(payment)}
                      >
                        Edit
                      </button>
                      {payment.paymentStatus === 'PENDING' && (
                        <button
                          className="btn btn-success"
                          onClick={() => handleProcessPayment(payment.id)}
                        >
                          Process
                        </button>
                      )}
                      {payment.paymentStatus === 'SUCCESS' && (
                        <button
                          className="btn btn-warning"
                          onClick={() => handleStatusUpdate(payment.id, 'REFUNDED')}
                        >
                          Refund
                        </button>
                      )}
                      <button
                        className="btn btn-danger"
                        onClick={() => handleDelete(payment.id)}
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

export default Payments;
