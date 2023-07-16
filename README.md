# Supermarket Insights: Leveraging SQL for Data Analysis and Decision Making

This project focuses on analyzing supermarket data using SQL queries to extract insights and make data-driven decisions. It involves analyzing product popularity, customer shopping patterns, associations, and optimizing inventory based on the dataset.

## Project Overview

The goal of this project is to analyze the supermarket data using SQL queries and uncover meaningful patterns and associations. By examining product popularity, customer shopping patterns, and other relevant factors, the project aims to provide actionable insights for improving various aspects of supermarket operations.

## Tools and Technologies

- **SQL:** Utilize SQL for data analysis and querying.
- **Database Management System:** Employ a suitable DBMS (e.g., MySQL, PostgreSQL) to store and manage the supermarket dataset.

## DDL (Data Definition Language)

The DDL section includes the SQL statements for creating the necessary database tables: aisles, departments, product, orders, and order_product. Foreign key constraints are also defined to establish relationships between the tables.

## DML (Data Manipulation Language)

The DML section includes SQL statements for importing the provided dataset into the corresponding database tables using the LOAD DATA LOCAL INFILE command.

## SQL Queries and Analysis

- **Top 10 Products Sales For Each Day of the Week:** This query retrieves the top 10 products sold for each day of the week, based on total sales volume.

- **5 Most Popular Products in Each Aisle from Monday to Friday:** This query identifies the five most popular products in each aisle from Monday to Friday, considering the total sales volume.

- **Top 10 Products with the Highest Reorder Rate:** This query determines the top 10 products with the highest reorder rate, indicating the products that are frequently reordered.

- **Shopper’s Aisle List for Each Order:** This query provides the aisle list for each order, linking the order_product and aisles tables.

- **Most Popular Shopping Paths:** This query identifies the most popular shopping paths by grouping orders based on the aisles visited and counting the occurrence of each path.

- **Top Pairwise Associations in Products:** This query discovers the top pairwise associations between products based on their co-occurrence within orders, helping to identify product associations and potential cross-selling opportunities.

## Getting Started

To get started with the project, follow these steps:

1. Clone the project repository to your local machine.
2. Set up the necessary database management system (e.g., MySQL, PostgreSQL).
3. Import the provided supermarket dataset into the database.
4. Use SQL queries to analyze the data and extract insights.
5. Document the analysis findings and recommendations.

Thank you for your interest in the "Supermarket SQL Project"!
