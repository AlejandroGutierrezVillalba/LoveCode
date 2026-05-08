package com.lovecode;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

public class usuarioDAO {

    public boolean registrar(usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, email, password, descripcion, ciudad) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String passwordHash = BCrypt.hashpw(usuario.getPassword(), BCrypt.gensalt());
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, passwordHash);
            ps.setString(4, usuario.getDescripcion());
            ps.setString(5, usuario.getCiudad());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            return false;
        }
    }

    public usuario login(String email, String password) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        String sqlHistorial = "INSERT INTO login_historial (id_usuario, email_intento, resultado) VALUES (?, ?, ?)";

        try (Connection con = conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashGuardado = rs.getString("password");
                if (BCrypt.checkpw(password, hashGuardado)) {
                    usuario u = new usuario();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setNombre(rs.getString("nombre"));
                    u.setEmail(rs.getString("email"));
                    u.setDescripcion(rs.getString("descripcion"));
                    u.setCiudad(rs.getString("ciudad"));
                    u.setFechaRegistro(rs.getString("fecha_registro"));

                    try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                        psH.setInt(1, u.getIdUsuario());
                        psH.setString(2, email);
                        psH.setString(3, "exito");
                        psH.executeUpdate();
                    }
                    return u;
                }
            }

            try (PreparedStatement psH = con.prepareStatement(sqlHistorial)) {
                psH.setNull(1, java.sql.Types.INTEGER);
                psH.setString(2, email);
                psH.setString(3, "fallo");
                psH.executeUpdate();
            }

        } catch (SQLException e) {
            System.err.println("Error en login: " + e.getMessage());
        }
        return null;
    }

    public List<usuario> obtenerTodos() {
        List<usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE activo = 1";
        try (Connection con = conexion.getConexion();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                usuario u = new usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setNombre(rs.getString("nombre"));
                u.setEmail(rs.getString("email"));
                u.setDescripcion(rs.getString("descripcion"));
                u.setCiudad(rs.getString("ciudad"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                lista.add(u);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuarios: " + e.getMessage());
        }
        return lista;
    }
}