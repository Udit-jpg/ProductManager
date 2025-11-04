import React, { useState } from 'react';
import './App.css';
import Users from './components/Users';
import Products from './components/Products';
import Orders from './components/Orders';
import Payments from './components/Payments';

function App() {
  const [activeTab, setActiveTab] = useState('users');

  return (
    <div className="App">
      <header className="App-header">
        <h1>🛍️ Product Manager - Microservices</h1>
        <nav className="nav-tabs">
          <button 
            className={activeTab === 'users' ? 'active' : ''} 
            onClick={() => setActiveTab('users')}
          >
            👥 Users
          </button>
          <button 
            className={activeTab === 'products' ? 'active' : ''} 
            onClick={() => setActiveTab('products')}
          >
            📦 Products
          </button>
          <button 
            className={activeTab === 'orders' ? 'active' : ''} 
            onClick={() => setActiveTab('orders')}
          >
            🛒 Orders
          </button>
          <button 
            className={activeTab === 'payments' ? 'active' : ''} 
            onClick={() => setActiveTab('payments')}
          >
            💳 Payments
          </button>
        </nav>
      </header>

      <main className="App-main">
        {activeTab === 'users' && <Users />}
        {activeTab === 'products' && <Products />}
        {activeTab === 'orders' && <Orders />}
        {activeTab === 'payments' && <Payments />}
      </main>

      <footer className="App-footer">
        <p>Microservices Architecture | User: 8081 | Product: 8082 | Order: 8083 | Payment: 8084</p>
      </footer>
    </div>
  );
}

export default App;
