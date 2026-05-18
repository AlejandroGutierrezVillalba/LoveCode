package com.lovecode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    public List<Integer> obtenerLikesDados(int idUsuario) {
    List<Integer> lista = new ArrayList<>();
    String sql = "SELECT id_usuario_destino FROM likes WHERE id_usuario_origen = ?";

    try (Connection con = conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            lista.add(rs.getInt("id_usuario_destino"));
        }
    } catch (SQLException e) {
        System.err.println("Error al obtener likes dados: " + e.getMessage());
    }
    return lista;
}
}