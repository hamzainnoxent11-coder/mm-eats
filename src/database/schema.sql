CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(30) UNIQUE NOT NULL,
  email VARCHAR(150),
  password_hash TEXT,
  role VARCHAR(30) NOT NULL DEFAULT 'CUSTOMER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(30),
  address TEXT,
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  image_url TEXT,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE menu_items (
  id SERIAL PRIMARY KEY,
  restaurant_id INT NOT NULL REFERENCES restaurants(id),
  category_id INT REFERENCES categories(id),
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES users(id),
  restaurant_id INT NOT NULL REFERENCES restaurants(id),
  rider_id INT REFERENCES users(id),
  status VARCHAR(40) NOT NULL DEFAULT 'PLACED',
  subtotal DECIMAL(10, 2) DEFAULT 0,
  delivery_fee DECIMAL(10, 2) DEFAULT 0,
  discount DECIMAL(10, 2) DEFAULT 0,
  total DECIMAL(10, 2) DEFAULT 0,
  delivery_address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id INT NOT NULL REFERENCES menu_items(id),
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  order_id INT NOT NULL REFERENCES orders(id),
  method VARCHAR(30) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  amount DECIMAL(10, 2) NOT NULL,
  transaction_id VARCHAR(150),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(50),
  address TEXT NOT NULL,
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7)
);

CREATE TABLE reviews (
  id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES users(id),
  restaurant_id INT NOT NULL REFERENCES restaurants(id),
  order_id INT REFERENCES orders(id),
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
