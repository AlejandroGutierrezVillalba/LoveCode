package com.lovecode;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Main 
{
    public static void main(String[] args) 
    {
        System.out.println("Iniciando aplicación LoveCode");
        
        try (Connection conexion = Conexion.getConexion()) 
        {
            if (conexion != null) 
            {
                System.out.println(" Conexion exitosa a la base de datos LoveCode");

                //  CONSULTA TABLA DE USUARIOS PARA VER SI HAY DATOS
                Statement stmt = conexion.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM Usuarios");

                System.out.println(" Lista de Usuarios en la base de datos:");
                boolean hayUsuarios = false;
                
                while (rs.next()) {
                    hayUsuarios = true;
                    
                    System.out.println("ID: " + rs.getInt(1) + " | Usuario: " + rs.getString(2));
                }
                
                if (!hayUsuarios) {
                    System.out.println(" La conexión y la consulta funcionaron, pero la tabla 'Usuarios' está vacía.");
                }
                System.out.println("----------------------------\n");
            }
        } catch (SQLException e) 
        {
            System.err.println(" Error en la base de datos: " + e.getMessage());
        }
    }
}