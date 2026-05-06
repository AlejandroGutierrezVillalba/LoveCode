package com.lovecode;

import java.sql.*;

public class likeDAO {

    public String registrarLike(int idOrigen, int idDestino) {
        String sql = "INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (?, ?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOrigen);
            ps.setInt(2, idDestino);
            ps.executeUpdate();
            return "Like registrado correctamente";

        } catch (SQLException e) {
            if (e.getMessage().contains("autolike")) {
                return "Un usuario no puede darse like a si mismo";
            }
            if (e.getMessage().contains("Duplicate")) {
                return "Ya has dado like a este usuario";
            }
            return "Error al registrar like: " + e.getMessage();
        }
    }
}