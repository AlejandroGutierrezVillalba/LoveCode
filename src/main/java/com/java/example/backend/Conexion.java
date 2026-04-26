package com.java.example.backend;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion 
{

    private static final String URL      = "jdbc:mariadb://192.168.171.131:3306/lovecode";
    private static final String USUARIO  = "desarrollador";
    private static final String PASSWORD = "desarrollador";

    public static Connection getConexion() throws SQLException 
    {
        return DriverManager.getConnection(URL, USUARIO, PASSWORD);
    }
}