package com.lovecode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class tecnologiaDAO {

    public List<String[]> obtenerTodas() {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT id_tecnologia, nombre, categoria FROM tecnologias ORDER BY categoria, nombre";
        try (Connection con = conexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                lista.add(new String[]{
                    rs.getString("id_tecnologia"),
                    rs.getString("nombre"),
                    rs.getString("categoria")
                });
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener tecnologias: " + e.getMessage());
        }
        return lista;
    }

    public boolean guardarTecnologiasUsuario(int idUsuario, int idTecnologia, String nivel) {
        String sql = "INSERT INTO usuarios_tecnologias (id_usuario, id_tecnologia, nivel) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE nivel = ?";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idTecnologia);
            ps.setString(3, nivel);
            ps.setString(4, nivel);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al guardar tecnologia: " + e.getMessage());
            return false;
        }
    }
}