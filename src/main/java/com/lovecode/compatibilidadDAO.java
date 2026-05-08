package com.lovecode;

import java.sql.*;

public class compatibilidadDAO {

    public String obtenerCompatibilidad(int idUsuario1, int idUsuario2) {
        String sql = "{CALL pa_compatibilidad(?, ?)}";
        try (Connection con = conexion.getConexion();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, idUsuario1);
            cs.setInt(2, idUsuario2);
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                return "Tecnologias en comun: " + rs.getInt("tecnologias_comunes") +
                       " | Tecnologias usuario1: " + rs.getInt("tecnologias_usuario1") +
                       " | Compatibilidad: " + rs.getDouble("porcentaje_compatibilidad") + "%";
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener compatibilidad: " + e.getMessage());
        }
        return "No se pudo calcular la compatibilidad";
    }
}