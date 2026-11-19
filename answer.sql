-- ============================================================================
-- Question 1: Achieving First Normal Form (1NF)
-- ============================================================================
-- In the original ProductDetail table, the 'Products' column contains multiple
-- comma-separated values in a single cell, violating 1NF (atomicity).
-- Below, we create a 1NF-compliant table where each row holds one product
-- per order and define a composite primary key on (OrderID, Product).

CREATE TABLE IF NOT EXISTS ProductDetail_1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');


-- ============================================================================
-- Question 2: Achieving Second Normal Form (2NF)
-- ============================================================================
-- Partial Dependency Identified:
-- With composite primary key (OrderID, Product), 'CustomerName' depends only
-- on 'OrderID' (a partial key dependency), not on the full composite key.
--
-- To achieve 2NF, we separate order-level data into 'Orders' and line-item
-- data (product and quantity per order) into 'OrderItems'.

CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS OrderItems (
    OrderID INT NOT NULL,
    Product VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (OrderID, Product),
    CONSTRAINT fk_orderitems_orders
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Orders (OrderID, CustomerName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Clark');

INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
    (101, 'Laptop', 2),
    (101, 'Mouse', 1),
    (102, 'Tablet', 3),
    (102, 'Keyboard', 1),
    (102, 'Mouse', 2),
    (103, 'Phone', 1);
