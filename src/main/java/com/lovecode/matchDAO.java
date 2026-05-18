package com.lovecode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class matchDAO {

    public List<String[]> obtenerMatches(int idUsuario) {
        List<String[]> lista = new ArrayList<>();
        String sql = "SELECT u1.nombre, u2.nombre, m.fecha_match " +
                     "FROM matches m " +
                     "JOIN usuarios u1 ON m.id_usuario1 = u1.id_usuario " +
                     "JOIN usuarios u2 ON m.id_usuario2 = u2.id_usuario " +
                     "WHERE m.id_usuario1 = ? OR m.id_usuario2 = ?";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                lista.add(new String[]{
                    rs.getString(1),
                    rs.getString(2),
                    rs.getString(3)
                });
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener matches: " + e.getMessage());
        }
        return lista;
    }

    public String generarXML(int idUsuario) {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        xml.append("<?xml-stylesheet type=\"text/xsl\" href=\"/matches.xsl\"?>\n");
        xml.append("<matches>\n");

        String sql = "SELECT m.id_match, u1.nombre AS nombre1, u2.nombre AS nombre2, " +
                     "m.fecha_match, t.nombre AS tecnologia " +
                     "FROM matches m " +
                     "JOIN usuarios u1 ON m.id_usuario1 = u1.id_usuario " +
                     "JOIN usuarios u2 ON m.id_usuario2 = u2.id_usuario " +
                     "JOIN usuarios_tecnologias ut1 ON ut1.id_usuario = u1.id_usuario " +
                     "JOIN usuarios_tecnologias ut2 ON ut2.id_usuario = u2.id_usuario " +
                     "AND ut2.id_tecnologia = ut1.id_tecnologia " +
                     "JOIN tecnologias t ON t.id_tecnologia = ut1.id_tecnologia " +
                     "WHERE m.id_usuario1 = ? OR m.id_usuario2 = ? " +
                     "ORDER BY m.id_match, t.nombre";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setInt(2, idUsuario);
            ResultSet rs = ps.executeQuery();

            int idMatchActual = -1;

            while (rs.next()) {
                int idMatch = rs.getInt("id_match");

                if (idMatch != idMatchActual) {
                    if (idMatchActual != -1) {
                        xml.append("    </tecnologias_comunes>\n");
                        xml.append("  </match>\n");
                    }
                    idMatchActual = idMatch;
                    xml.append("  <match>\n");
                    xml.append("    <usuario1>").append(rs.getString("nombre1")).append("</usuario1>\n");
                    xml.append("    <usuario2>").append(rs.getString("nombre2")).append("</usuario2>\n");
                    xml.append("    <fecha>").append(rs.getString("fecha_match")).append("</fecha>\n");
                    xml.append("    <tecnologias_comunes>\n");
                }

                xml.append("      <tecnologia>").append(rs.getString("tecnologia")).append("</tecnologia>\n");
            }

            if (idMatchActual != -1) {
                xml.append("    </tecnologias_comunes>\n");
                xml.append("  </match>\n");
            }

        } catch (SQLException e) {
            System.err.println("Error al generar XML: " + e.getMessage());
        }

        xml.append("</matches>");
        return xml.toString();
    }
}